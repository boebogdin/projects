//
//  DetailScreenViewController.swift
//  LifeForm-Search
//
//  Created by Boe Bogdin on 1/22/23.
//

import UIKit

class DetailScreenViewController: UIViewController {
    
    enum ImageError: Error {
        case couldNotDecodeImage
        case couldNotFetchImage
    }
    
    @IBOutlet weak var animalImageView: UIImageView!
    
    var animalToShow: Animal? = nil
    
    @IBOutlet weak var scientifcNameLabel: UILabel!
    
    @IBOutlet weak var imageLinkLabel: UILabel!
    
    var taxonObject: TaxonObject? {
        didSet {
            Task {
                scientifcNameLabel.text = taxonObject?.scientificName
                
                imageLinkLabel.text = taxonObject?.dataObjects.first?.license
                animalImageView.image = try await UIImage(data: getImage(url: taxonObject!.dataObjects.first?.mediaURL ?? " "))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let animalId = animalToShow?.id {
            sendPageRequest(id: animalId)
        }
    }
    
    func sendPageRequest(id: Int) {
        Task {
            do {
                let request = TaxonRequest(animalID: String(id))
                
                let data = try await URLSession.shared.data(for: request.urlRequest)
                
                let taxonResponse = try request.decodeResponse(data: data.0)
                
                taxonObject = taxonResponse.taxonConcept
                
                
            } catch {
                print("error finding taxonObject")
                throw error
            }
            
        }
    }
    
    func getImage(url: String) async throws -> Data {
        
        do {
            let urlString = URL(string: url)
            let data = try await URLSession.shared.data(from: urlString!)
            
            return data.0
            
        } catch {
            print("Could not fetch image data")
            throw error
            
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

