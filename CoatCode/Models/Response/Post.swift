//
//  Post.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/07.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct Post: Codable {
    
//    var owner: User?
    var content: String?
    var contentImages: [String?]
    var likeCount: Int?
    var commentCount: Int?
    var viewCount: Int?
    
    private enum CodingKeys: String, CodingKey {
//        case owner
        case content
        case contentImages
        case likeCount
        case commentCount
        case viewCount
    }
    
}
