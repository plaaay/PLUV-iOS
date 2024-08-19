//
//  SelectMusicViewModel.swift
//  PLUV
//
//  Created by 백유정 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectMusicViewModel {
    var playlistItem: Playlist = Playlist(id: "", thumbnailURL: "", songCount: nil, name: "", source: .apple)
    var musicItem: Observable<[Music]> = Observable.just([])
    let disposeBag = DisposeBag()
    
    func musicItemCount(completion: @escaping (Int) -> Void)  {
        musicItem
            .map { $0.count }
            .subscribe(onNext: { count in
                completion(count)
            })
            .disposed(by: disposeBag)
    }
}
