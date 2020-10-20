//
//  FeedSection.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/20.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxDataSources

enum FeedSection {
    case feed(title: String, items: [FeedSectionItem])
}

enum FeedSectionItem {
    case postItem(viewModel: PostCellViewModel)
    case commentPreviewItem(viewModel: )
}

extension FeedSection: SectionModelType {
    typealias Item = FeedSectionItem
    
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
    
    init(original: FeedSection, items: [Item]) {
        switch original {
        case .feed(let title, let items):
            self = .feed(title: title, items: items)
        }
    }
}
