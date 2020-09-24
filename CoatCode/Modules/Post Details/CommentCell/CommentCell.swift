//
//  CommentCell.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/22.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(to viewModel: CommentCellViewModel) {
        
    }
    
}
