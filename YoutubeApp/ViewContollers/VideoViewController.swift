//
//  VideoViewController.swift
//  YoutubeApp
//
//  Created by user on 2021/03/31.
//

import UIKit
import Nuke

class VideoViewController: UIViewController {
    
    var selectedItem: Item?
    private var imageViewCenterY: CGFloat?
    
    var videoImageMaxY: CGFloat {
        let ecludeValue = view.safeAreaInsets.bottom + (imageViewCenterY ?? 0)
        return view.frame.maxY -  ecludeValue
    }
    
    var minimumImageViewTrailingConstraint: CGFloat {
        view.frame.width - (150 + 12)
    }
    
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var videiImageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoImageBackView: UIView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var describeView: UIView!
    @IBOutlet weak var describeViewTTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var baseBackGroundView: UIView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.baseBackGroundView.alpha = 1
        }
    }
    
    
    private func setupViews() {
        self.view.bringSubviewToFront(videoImageView)
        
        imageViewCenterY = videoImageView.center.y
        
        channelImageView.layer.cornerRadius = 45 / 2
        
        if let url = URL(string: selectedItem?.snippet.thumbnails.medium.url ?? "") {
            Nuke.loadImage(with: url, into: videoImageView)
        }
        
        if let channelUrl = URL(string: selectedItem?.channel?.items[0].snippet.thumbnails.medium.url ?? "") {
            Nuke.loadImage(with: channelUrl, into: channelImageView)
        }
        
        videoTitleLabel.text = selectedItem?.snippet.title
        channelTitleLabel.text = selectedItem?.channel?.items[0].snippet.title
        
        let panGeture = UIPanGestureRecognizer(target: self, action: #selector(panVideoImageView))
        videoImageView.addGestureRecognizer(panGeture)
        
        print("videoImageMaxY: ",videoImageMaxY)
    }
    
    @objc private func panVideoImageView(gesture: UIPanGestureRecognizer) {
        
        guard let imageView = gesture.view else { return }
        let move = gesture.translation(in: imageView)
        
        if gesture.state == .changed {
            
            if videoImageMaxY <= move.y {
                moveTopBottom(imageView: imageView as! UIImageView)
                return
            }
            
            imageView.transform = CGAffineTransform(translationX: 0, y: move.y)
            videoImageBackView.transform = CGAffineTransform(translationX: 0, y: move.y)
            
            self.adjustPaddingChange(move: move)
            
            self.adjustHeightChange(move: move)
            
            self.adjustAlphaChange(move: move)
            
            self.adjustWidthChange(move: move)
            
        } else if gesture.state == .ended {
            
            self.imageViewEndedAnimation(move: move, imageView: imageView as! UIImageView)
            
        }
    }
    
// MARK: imageViewのpanGestureのstateが、[.change]の時の動き
    private func adjustPaddingChange(move: CGPoint) {
        let movingConstant = move.y / 30
        
        if movingConstant <= 12 {
            videiImageViewTrailingConstraint.constant = movingConstant
            videoImageViewLeadingConstraint.constant = movingConstant
            
            backViewTrailingConstraint.constant = movingConstant
        }
    }
    
    private func adjustHeightChange(move: CGPoint) {
        let parantViewHeight = self.view.frame.height
        let heightRatio = 210 / videoImageMaxY
        let moveHeight = move.y * heightRatio
        
        backViewTopConstraint.constant = move.y
        videoImageViewHeightConstraint.constant = 280 - moveHeight
        describeViewTTopConstraint.constant = move.y * 0.8
        
        let bottomMoveY = parantViewHeight - videoImageMaxY
        let bottomMoveRatio = bottomMoveY / videoImageMaxY
        let bottomMoveConstant = move.y * bottomMoveRatio
        backViewBottomConstraint.constant = bottomMoveConstant
    }
    
    private func adjustAlphaChange(move: CGPoint) {
        let alphaRatio = move.y / (self.view.frame.height / 2)
        describeView.alpha = 1 - alphaRatio
        baseBackGroundView.alpha = 1 - alphaRatio
    }
    
    private func adjustWidthChange(move: CGPoint) {
        let originalWidth = self.view.frame.width
        let constant = originalWidth - move.y
        
        if minimumImageViewTrailingConstraint > constant {
            videiImageViewTrailingConstraint.constant = minimumImageViewTrailingConstraint
            return
        }
        
        if constant < -12 {
            videiImageViewTrailingConstraint.constant = constant
        }
    }
// MARK: imageViewのpanGestureのstateが、[.ended]の時の動き
    private func imageViewEndedAnimation(move: CGPoint, imageView: UIImageView) {
        if move.y < self.view.frame.height / 3 {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                
                self.backToIdentityAllViews(imageView: imageView)
                
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                
                self.moveTopBottom(imageView: imageView)
                
            } completion: { _ in
                
                UIView.animate(withDuration: 0.2) {
                    
                    self.videoImageView.isHidden = true
                    self.videoImageBackView.isHidden = true
                    
                    let image = self.videoImageView.image
                    let useInfo: [String: Any] = ["image": image, "videoImageMinY": self.videoImageView.frame.minY]
                    
                    NotificationCenter.default.post(name: .init("thumbnailImage"), object: nil, userInfo: useInfo as [AnyHashable : Any])
                    
                } completion: { _ in
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    private func moveTopBottom(imageView: UIImageView) {
        imageView.transform = CGAffineTransform(translationX: 0, y: videoImageMaxY)
        videiImageViewTrailingConstraint.constant = minimumImageViewTrailingConstraint
        videoImageViewHeightConstraint.constant = 70
        videoImageViewLeadingConstraint.constant = 12
        
        videoImageBackView.transform = CGAffineTransform(translationX: 0, y: videoImageMaxY)
        describeView.alpha = 0
        backView.alpha = 0
        baseBackGroundView.alpha = 0
        
        self.view.layoutIfNeeded()
    }
    
    private func backToIdentityAllViews(imageView: UIImageView) {
        
        imageView.transform = .identity
        videoImageBackView.transform = .identity
        videoImageViewHeightConstraint.constant = 280
        videoImageViewLeadingConstraint.constant = 0
        videiImageViewTrailingConstraint.constant = 0
        
        backViewTrailingConstraint.constant = 0
        backViewBottomConstraint.constant = 0
        backViewTopConstraint.constant = 0
        backView.alpha = 1
        
        describeViewTTopConstraint.constant = 0
        describeView.alpha = 1
        
        baseBackGroundView.alpha = 1
        
        self.view.layoutIfNeeded()
    }
}
