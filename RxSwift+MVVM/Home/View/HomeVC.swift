//
//  HomeVC.swift
//  RxSwift+MVVM
//
//  Created by Mustafa GUNES on 12.02.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeVC: UIViewController {
    
    // MARK : - Outlets
    @IBOutlet weak var tracksVCView: UIView!
    @IBOutlet weak var albumsVCView: UIView!
    
    // MARK : - Global Definitions
    let disposeBag = DisposeBag()
    var homeViewModel = HomeViewModel()
    
    private lazy var albumsViewController: AlbumsCollectionViewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AlbumsCollectionViewVC") as! AlbumsCollectionViewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: albumsVCView)
        
        return viewController
    }()
    
    private lazy var tracksViewController: TracksTableViewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "TracksTableViewVC") as! TracksTableViewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: tracksVCView)
        
        return viewController
    }()

    
    /// Views Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBlurArea(area: self.view.frame, style: .dark)
        self.setupBindings()
        homeViewModel.requestData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    /// Bindings
    private func setupBindings() {
        // binding loading to vc
        homeViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        // observing errors to show
        homeViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            }) .disposed(by: disposeBag)
        
        // binding albums to album container
        homeViewModel
            .albums
            .observeOn(MainScheduler.instance)
            .bind(to: albumsViewController.albums)
            .disposed(by: disposeBag)
        
        // binding tracks to track container
        homeViewModel
            .tracks
            .observeOn(MainScheduler.instance)
            .bind(to: tracksViewController.tracks)
            .disposed(by: disposeBag)
    }
}
