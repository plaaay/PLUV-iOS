//
//  TransferDestinationViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TransferDestinationViewController: UIViewController {
    
    private let sourceTitleView = UIView()
    private let sourceView = UIView()
    private let sourceMusicImageView = UIImageView()
    private let sourceMusicLabel = UILabel()
    private let dotView = UIView()
    
    private let sourceTitleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    private let sourceTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(TransferTableViewCell.self, forCellReuseIdentifier: TransferTableViewCell.identifier)
    }
    
    
    
    var sourcePlatform: MusicPlatform = .AppleMusic
    private var destinationList = Observable.just(MusicPlatform.allCases)
    private let destinationTitleView = UIView()
    private let destinationTitleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    private let destinationTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(TransferTableViewCell.self, forCellReuseIdentifier: TransferTableViewCell.identifier)
    }
    private var moveView = MoveView(view: UIViewController())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setData()
    }
}

extension TransferDestinationViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(destinationTitleView)
        destinationTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(124)
        }
        
        self.destinationTitleView.addSubview(destinationTitleLabel)
        destinationTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(28)
        }
        destinationTitleLabel.text = "어디로\n플레이리스트를 옮길까요?"
        
        self.view.addSubview(destinationTableView)
        destinationTableView.snp.makeConstraints { make in
            make.top.equalTo(destinationTitleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        moveView.trasferButton.isEnabled = false
    }
    
    private func setData() {
        var platformList = MusicPlatform.allCases
        platformList.removeAll { platform in
            if sourcePlatform == platform {
                return true
            }
            return false
        }
        
        self.destinationList = Observable.just(platformList)
        
        self.destinationTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.destinationTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.destinationTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.destinationTableView.rx.modelSelected(MusicPlatform.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] platform in
                
            })
            .disposed(by: disposeBag)
        
        self.destinationList
            .bind(to: self.destinationTableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TransferTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as! TransferTableViewCell
                cell.prepare(platform: item)
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    private func tmpData() {
        sourceMusicImageView.backgroundColor = .green
        sourceMusicLabel.text = "스포티파이"
    }
    
    private func setTmpData() {
        sourceMusicImageView.isHidden = false
    }
}

extension TransferDestinationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
