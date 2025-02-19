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
    var musicItem = BehaviorRelay<[Music]>(value: [])
    let selectedMusic = BehaviorRelay<[Music]>(value: [])
    let disposeBag = DisposeBag()
    
    func musicItemCount(completion: @escaping (Int) -> Void)  {
        musicItem
            .map { $0.count }
            .subscribe(onNext: { count in
                completion(count)
            })
            .disposed(by: disposeBag)
    }
    
    func musicSelect(music: Music) {
        var currentSelect = selectedMusic.value
        
        if let index = currentSelect.firstIndex(where: { $0.title == music.title && $0.artistNames == music.artistNames }) {
            currentSelect.remove(at: index)
        } else {
            currentSelect.append(music)
        }
        
        selectedMusic.accept(currentSelect)
    }
}
