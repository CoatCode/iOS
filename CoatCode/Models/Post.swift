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
    var title: String // 제목
    var content: String? // 내용
    var imageURLs: [URL] // 이미지 url들
    var likedPeople: [Int]? // 좋아요한 사람들 id
    var likeCount: Int // 좋아요 수
    var commentCount: Int // 댓글 수
    var viewCount: Int // 조회수
    var tag: [String]? // 태그
    var createdAt: Date // 생성날짜
    var commentPreview: [Comment]?

    private enum CodingKeys: String, CodingKey {
        case id
        case owner
        case title
        case content
        case imageURLs = "image_urls"
        case likedPeople = "liked_people"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case viewCount = "view_count"
        case tag
        case createdAt = "created_at"
        case commentPreview = "comment_preview"
    }
}
