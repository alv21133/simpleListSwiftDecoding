//
//  RestoTableViewCell.swift
//  GoFood
//
//  Created by Wahyu on 04/07/21.
//

import UIKit

class RestoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoResto: UIImageView!
    @IBOutlet weak var nameResto: UILabel!
    @IBOutlet weak var descResto: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
