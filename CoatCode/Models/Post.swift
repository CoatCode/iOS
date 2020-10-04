//
//  Post.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/07.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct Post: Codable {
    
    var id: Int // 게시물 아이디
    var owner: User // 작성자 모델 (get User와 동일한 값)
    var title: String? // 제목
    var content: String? // 내용
    var imageURLs: [URL]? // 이미지 url들
    var likeCount: Int // 좋아요 수
    var commentCount: Int // 댓글 수
    var viewCount: Int // 조회수
    var isLiked: Bool? // 좋아요 API 에서 받아올 것
    var tag: String? // 태그
    var createdAt: Date // 생성날짜
    
    private enum CodingKeys: String, CodingKey {
        case id
        case owner
        case title
        case content
        case imageURLs = "image_urls"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case viewCount = "view_count"
        case tag
        case createdAt = "created_at"
    }
}

// json값
//{
//    "id": 0,
//    "owner": {
//        "email": "",
//        "username": "user1",
//        "profile": ""
//    },
//    "liked_peoples": ["user1_id", "user2_id",  ...],
//    "title": "",
//    "content": "",
//    "content_images": ["image_url1", "image_url2", ...],
//    "like_count": 0,
//    "comment_count": 0,
//    "view_count": 0,
//    "tag": "#a#b#c",
//    "created_at": ""
//}
