//
//  SearchTableViewCell.swift
//  LifeForm-Search
//
//  Created by Boe Bogdin on 1/20/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var scientificNameLabel: UILabel!
    
    @IBOutlet weak var commonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
