//
//  HomeViewModel.swift
//  RxSwift+MVVM
//
//  Created by Mustafa GUNES on 12.02.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeViewModel {
    
    private let disposable = DisposeBag()
    
    public enum homeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let albums : PublishSubject<[Album]> = PublishSubject()
    public let tracks : PublishSubject<[Track]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<homeError> = PublishSubject()
    
    public func requestData(){
        self.loading.onNext(true)
        
        APIManager.requestData(url: "96169aa4b23d4caf887dc90b783ed2a5/raw/452449880adcc7c99550431ff387b21fb93ac502/RxSwift+MVVM.json", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson):
                let albums = returnJson["Albums"].arrayValue.compactMap {return Album(data: try! $0.rawData())}
                let tracks = returnJson["Tracks"].arrayValue.compactMap {return Track(data: try! $0.rawData())}
                self.albums.onNext(albums)
                self.tracks.onNext(tracks)
            
            case .failure(let failure):
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
        
    }
}
