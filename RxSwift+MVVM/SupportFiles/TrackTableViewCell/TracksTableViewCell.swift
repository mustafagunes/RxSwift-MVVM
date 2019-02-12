//
//  TracksTableViewCell.swift
//  RxSwift+MVVM
//
//  Created by Mustafa GUNES on 12.02.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import UIKit

class TracksTableViewCell: UITableViewCell {

    // MARK : - Outlets
    @IBOutlet weak var trackImage : UIImageView!
    @IBOutlet weak var trackArtist : UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        trackImage.image = UIImage()
    }
    
    public var cellTrack: Track! {
        didSet {
            self.trackImage.clipsToBounds = true
            self.trackImage.layer.cornerRadius = 3
            self.trackImage.loadImage(fromURL: cellTrack.trackArtWork)
            self.trackTitle.text = cellTrack.name
            self.trackArtist.text = cellTrack.artist
        }
    }
}
