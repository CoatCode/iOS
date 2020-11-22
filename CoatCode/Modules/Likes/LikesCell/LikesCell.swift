//
//  LikesCell.swift
//  CoatCode
//
//  Created by 강민석 on 2020/11/19.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

class LikesCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImage.roundCorners(.allCorners, radius: 0.5 * profileImage.frame.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
