//
//  PhotoCell.swift
//  iOS_Flickr_DEMO
//
//  Created by Steven Zeng on 2019/3/5.
//  Copyright © 2019 ZengSQi. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
    }

}
