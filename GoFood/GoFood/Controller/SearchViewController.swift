//
//  SearchViewController.swift
//  GoFood
//
//  Created by Wahyu on 22/07/21.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchViewController: UIViewController , UITextFieldDelegate{    
    
    private var resultRestoFromSearch = [ResultResto](){
        didSet{
            resultTableView.reloadData()
        }
    }
    
    @IBOutlet weak var titleSearchPage: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    private var userKeyword = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.dataSource = self
        resultTableView.delegate = self
        searchTextField.delegate = self
        resultTableView.register(UINib(nibName: "RestoTableViewCell", bundle: nil), forCellReuseIdentifier: "RestoCell")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.userKeyword = [searchTextField.text! + string]                    
        return true
    }
    
    @IBAction func btnSearchResto(_ sender: Any) {
        getRestoListData()
    }
    
    func alerOnEmptyResult(Keyword:String){
        let alert = UIAlertController(
            title: "\(Keyword)",
            message: "Silahakan lihat referasi resto pada Home menu ya  🙏",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Oke", style: .default))
        self.present(alert, animated: true)
    }
    
    func getRestoListData() {
        if (userKeyword.count == 0) {
            alerOnEmptyResult(Keyword: "Oopss.... Kata pencarian masih kosong nih....!")
            return
        }
        guard let url = URL(string: "https://restaurant-api.dicoding.dev/search?q=\(userKeyword[0])") else {
            print("invalid Url")
            let message = "Oops..! Sepertinya kata pencarian tidak valid nih...."
            alerOnEmptyResult(Keyword: message )
            return
        }
        
        AF.request(url).responseJSON{(response) in
            
            switch response.result{
            case .success(let data):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let jsonRestoData = try JSONDecoder().decode(ResultResto.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.resultRestoFromSearch = [jsonRestoData]
                    }
                    
                    if jsonRestoData.restaurants .isEmpty {
                        let message = "Oops..! Resto ' \(self.userKeyword[0])' tidak di temukan.."
                        self.alerOnEmptyResult(Keyword: message)
                    }
                } catch let error as NSError {
                    print("Failed to decode JSON : \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
}


extension SearchViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultRestoFromSearch .isEmpty {
            return resultRestoFromSearch.count
        }else{
            return resultRestoFromSearch[0].founded
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestoCell" , for: indexPath ) as? RestoTableViewCell{
            
            let Resto = resultRestoFromSearch[0].restaurants[indexPath.row]
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

extension SearchViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let detailPage = DetailRestoViewController(nibName:"DetailRestoViewController", bundle: nil)
        detailPage.restoDetailId = [resultRestoFromSearch[0].restaurants[indexPath.row].id]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailPage, animated: true)
        
    }
    
}
