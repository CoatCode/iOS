//
//  PostDetailSection.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/22.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxDataSources

enum PostDetailSection {
    case post(title: String, items: [PostDetailSectionItem])
}

enum PostDetailSectionItem {
    case postDetailItem(viewModel: PostCellViewModel)
    case commentItem(viewModel: CommentCellViewModel)
}

extension PostDetailSection: SectionModelType {
    typealias Item = PostDetailSectionItem

    var title: String {
        switch self {
        case .post(let title, _):
            return title
        }
    }

    var items: [Item] {
        switch self {
        case .post(_, let items):
            return items.map { $0 }
        }
    }

    init(original: PostDetailSection, items: [Item]) {
        switch original {
        case .post(let title, let items):
            self = .post(title: title, items: items)
        }
    }
}
