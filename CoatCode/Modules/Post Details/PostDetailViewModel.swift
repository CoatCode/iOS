//
//  PostDetailViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class PostDetailViewModel: BaseViewModel {
    
    let post: BehaviorRelay<Post>
    
    init(with post: Post) {
        self.post = BehaviorRelay(value: post)
    }
    
    struct Input {
        
    }
    
    struct Output {
        let items: Observable<[PostDetailSection]>
    }
    
}

extension PostDetailViewModel {
    func transform(input: Input) -> Output {
        let items = post.map { post -> [PostDetailSection] in
            var items: [PostDetailSectionItem] = []
            let postDetailCellViewModel = PostDetailCellViewModel(with: self.post.value)
            items.append(PostDetailSectionItem.postDetailItem(viewModel: postDetailCellViewModel))
            
            return [PostDetailSection.post(title: "", items: items)]
        }
        
        return Output(items: items)
    }
}
