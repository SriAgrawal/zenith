//
//  ZNStampsTableViewCell.swift
//  Zenith
//
//  Created by Anjali on 03/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ZNStampsTableViewCell: UITableViewCell {
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!

    @IBOutlet var couponImageView5: UIImageView!
    @IBOutlet var couponImageView4: UIImageView!
    @IBOutlet var couponImageView3: UIImageView!
    @IBOutlet var couponImageView2: UIImageView!

    @IBOutlet var ratingView: RateView!
    override func awakeFromNib() {
        
        self.itemImageView.layer.cornerRadius = 5
        itemImageView.clipsToBounds = true
        itemImageView.layer.borderWidth = 1.0
        itemImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.45).cgColor
        itemImageView.layer.masksToBounds = false
        
        if UIScreen.main.bounds.width == 320 {
            itemNameLabel.font = UIFont(name: "ITCKabelStd-Medium", size: 16)
        }
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
