//
//  Track.swift
//  RxSwift+MVVM
//
//  Created by Mustafa GUNES on 12.02.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import Foundation

struct Track: Codable {
    let artist: String
    let id, name, trackArtWork, trackAlbum: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case trackArtWork = "track_art_work"
        case trackAlbum = "track_album"
        case artist
    }
}

extension Track {
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Track.self, from: data)
            self = me
        }
        catch {
            print("error Track: \(error)")
            return nil
        }
    }
}
