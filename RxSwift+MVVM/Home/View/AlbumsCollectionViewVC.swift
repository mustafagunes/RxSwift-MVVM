//
//  AlbumsCollectionViewVC.swift
//  RxSwift+MVVM
//
//  Created by Mustafa GUNES on 12.02.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AlbumsCollectionViewVC: UIViewController {
    
    // MARK : - Global Definitions
    private let disposeBag = DisposeBag()
    public var albums = PublishSubject<[Album]>()
    
    // MARK : - Outlets
    @IBOutlet private weak var albumsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupBinding() {
        albumsCollectionView.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: AlbumsCollectionViewCell.self))
        
        albums.bind(to: albumsCollectionView.rx.items(cellIdentifier: "AlbumsCollectionViewCell", cellType: AlbumsCollectionViewCell.self)) {  (row,album,cell) in
            cell.album = album
            cell.withBackView = true
            }.disposed(by: disposeBag)
        
        albumsCollectionView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
        })).disposed(by: disposeBag)
    }
}
