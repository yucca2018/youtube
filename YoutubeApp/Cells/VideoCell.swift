//
//  VideoCell.swift
//  YoutubeApp
//
//  Created by user on 2021/03/22.
//

import UIKit
import Nuke

class VideoCell: UICollectionViewCell {
    
    var videoItem: Item? {
        didSet {
            
            if let url = URL(string: videoItem?.snippet.thumbnails.medium.url ?? "") {
                Nuke.loadImage(with: url, into: thumbnailImageView)
            }
            
            if let channelUrl = URL(string: videoItem?.channel?.items[0].snippet.thumbnails.medium.url ?? "") {
                Nuke.loadImage(with: channelUrl, into: channelImageView)
            }
            
            titleLabel.text = videoItem?.snippet.title
            descriptionLabel.text = videoItem?.snippet.description
            
        }
    }
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        channelImageView.layer.cornerRadius = 40 / 2
    }
}
