//
//  Comment.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/24.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var id: Int // 댓글 아이디
    var owner: User // 작성자
    var content: String // 댓글 내용
    var createdAt: Date // 생성날짜

    private enum CodingKeys: String, CodingKey {
        case id = "comment_id"
        case owner
        case content
        case createdAt = "created_at"
    }
}
