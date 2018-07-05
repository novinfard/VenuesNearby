//
//  SpotTableViewCell.swift
//  VenuesNearby
//
//  Created by Soheil on 04/07/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import UIKit

class SpotTableViewCell: UITableViewCell {

	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var categories: UILabel!
	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var distance: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
