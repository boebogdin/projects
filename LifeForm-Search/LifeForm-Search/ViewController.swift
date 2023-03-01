//
//  ViewController.swift
//  LifeForm-Search
//
//  Created by Boe Bogdin on 1/20/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
     var results:  [Animal] = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var animalToSend: Animal? = nil
    
 //   @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        tableView.reloadData()
        Task {
            
            let searchRequest = SearchRequest(search: self.searchBar.text ?? " ")
            
            let requestData = try await URLSession.shared.data(for: searchRequest.urlRequest)
            
            
            let animalsResults = try searchRequest.decodeResponse(data: requestData.0)
            
            results = animalsResults.results
            tableView.reloadData()
            
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
   
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
        let currentResult = results[indexPath.row]
        cell.scientificNameLabel.text = currentResult.scientificName
        cell.commonNameLabel.text = currentResult.commonName
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animalToSend = results[indexPath.row]
       
       performSegue(withIdentifier: "segueToDetail", sender: nil)

    }
    
    @IBSegueAction func segueToDetail(_ coder: NSCoder, sender: Any?) -> DetailScreenViewController? {
        
        let detail = DetailScreenViewController(coder: coder)
        
        detail?.animalToShow = animalToSend
        
        return detail
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100

    }
}


extension Data {
    func prettyPrintedJsonString() {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self), let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]), let prettyJsonString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to fetch object")
            return
        }
        
        print(prettyJsonString)
    }
}
