//
//  ViewController.swift
//  GoFood
//
//  Created by Wahyu on 04/07/21.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
    
    @IBOutlet weak var RestoTableView: UITableView!
    @Published var restoList = [RestoData](){
        didSet{
            RestoTableView.reloadData()
        }
    }
    
    private let floatingChartButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        let chartImage = UIImage(named: "icons8-shopping-bag-100")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 14, right: 12)
        button.setImage(chartImage ,for: .normal)
        button.layer.borderWidth = 1.1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Resto Indonesia"
        view.addSubview(floatingChartButton)
        
        getRestoListData()
        RestoTableView.dataSource = self
        RestoTableView.delegate = self
        RestoTableView.register(UINib(nibName: "RestoTableViewCell", bundle: nil), forCellReuseIdentifier: "RestoCell")
        floatingChartButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingChartButton.frame = CGRect(
            x: view.frame.size.width - 70,
            y: view.frame.size.height - 150,
            width: 60,
            height: 60)
    }
    
    @objc private func didTapButton(){
        let alert = UIAlertController(
            title: "Pesanan Masih Kosong nih...",
            message: "Mohon maaf fitur masih belum sempurna, Cooming soon 🙏",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Oke", style: .default))
        self.present(alert, animated: true)
    }
    
    func getRestoListData() {
        guard let url = URL(string: "https://restaurant-api.dicoding.dev/list") else {
            print("invalid Url")
            return
        }
        
        AF.request(url).responseJSON{(response) in
            switch response.result{
            case .success(let data):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let jsonRestoData = try JSONDecoder().decode(RestoData.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.restoList = [jsonRestoData]
                    }
                } catch let error as NSError {
                    print("Failed to decode JSON : \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print(error)
                
            }
            
            
        }
        
    }
    
    @IBAction func handleViewProfile(_ sender: Any) {
        let profileVIew = ProfileViewController(nibName: "ProfileViewController", bundle: nil)        
        self.present(profileVIew, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if restoList .isEmpty {
            return restoList.count
        }else{
            return restoList[0].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestoCell" , for: indexPath ) as? RestoTableViewCell{
            
            let Resto = restoList[0].restaurants[indexPath.row]
            cell.nameResto.text = Resto.name
            cell.descResto.text = Resto.restaurantDescription
            let imageUrl = "https://restaurant-api.dicoding.dev/images/medium/\(Resto.pictureID)"
            
            AF.request(imageUrl).responseImage{ response in
                
                switch response.result{
                case .success(let RestoImage):
                    DispatchQueue.main.async {
                        cell.photoResto.image = RestoImage
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            }
            cell.photoResto.layer.cornerRadius  = cell.photoResto.frame.height / 15
            cell.photoResto.clipsToBounds = true
            
            return cell
            
        }else{
            print("Error table view cell brow ")
            return UITableViewCell()
        }
        
    }
    
    
}


extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailPage = DetailRestoViewController(nibName:"DetailRestoViewController", bundle: nil)
        detailPage.restoDetailId = [restoList[0].restaurants[indexPath.row].id]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailPage, animated: true)
        
    }
    
}
