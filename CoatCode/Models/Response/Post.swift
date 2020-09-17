//
//  Post.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/07.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct Post: Codable {
    
//    var owner: User? // 유저 모델
    var content: String? // 내용 (타이틀)
    var contentImages: [String?] // 이미지
    var likeCount: Int? // 좋아요수
    var commentCount: Int? // 댓글수
    var viewCount: Int? // 조회수
    var viewerHasLiked: Bool? // 좋아요를 했는지 여부
    
    private enum CodingKeys: String, CodingKey {
//        case owner
        case content
        case contentImages
        case likeCount
        case commentCount
        case viewCount
    }
    
}
