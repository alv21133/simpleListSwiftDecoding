//
//  DetailRestoViewController.swift
//  GoFood
//
//  Created by Wahyu on 13/07/21.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailRestoViewController: UIViewController {
    
    @IBOutlet weak var detailPhoto: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailRating: UILabel!
    @IBOutlet weak var detailCity: UILabel!
    @IBOutlet weak var detailDesc: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var detailAddress: UILabel!
    var restoDetailId =  [String]()
    var detailRestoData = [RestoDetail](){
        didSet{
            updatePage(detailRestoData[0].restaurant)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        getRestoDetailData()
        
    }
    
    func getRestoDetailData() {
        
        guard let url = URL(string: "https://restaurant-api.dicoding.dev/detail/\(restoDetailId[0])") else {
            print("invalid Url")
            return
        }
        
        AF.request(url).responseJSON{(response) in
            
            switch response.result{
            case .success(let data):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let jsonRestoData = try JSONDecoder().decode(RestoDetail.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.detailRestoData = [jsonRestoData]
                    }
                    
                    
                } catch let error as NSError {
                    print("Failed to decode JSON : \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print(error)
                
            }
        }        
    }
    
    func updatePage(_ resto: detailInfo){
        let imageUrl = "https://restaurant-api.dicoding.dev/images/medium/\(resto.pictureID)"
        self.detailTitle.text = resto.name
        self.detailRating.text = " : \(String(format: "%.1f", resto.rating))"
        self.detailCity.text = " : \(resto.city)"
        self.detailDesc.text = resto.restaurantDescription
        self.detailAddress.text = " : \(resto.address)"
        // get resto image
        AF.request(imageUrl).responseImage{response in
            
            switch response.result{
            case .success(let resultImage):
                DispatchQueue.main.async {
                    self.detailPhoto.image = resultImage
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func handleLikeAction(_ sender: Any) {
        let alert = UIAlertController(
            title: "Terimakasi telah menyukai Resto ini",
            message: "Mohon maaf fitur masih belum sempurna, Cooming soon 🙏",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Oke", style: .default){_ in 
            self.btnLike.setImage(UIImage(named: "icons8-love-90.png"), for: .normal) 
        })
        self.present(alert, animated: true)
    }
}
