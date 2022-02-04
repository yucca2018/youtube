//
//  BaseTabBarController.swift
//  YoutubeApp
//
//  Created by user on 2021/03/27.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    enum ControllerName: Int {
        case home, search, channel, inbox, library
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private  func setupViewControllers(){
        viewControllers?.enumerated().forEach({ (index, viewController) in
            if let name = ControllerName.init(rawValue: index) {
                switch name {
                case .home:
                    setTabbarInfo(viewController, selectedImageName: "_i_icon_11212_icon_112121_256", unselectedImageName: "_i_icon_11212_icon_112120_256", title: "ホーム")
                case .search:
                    setTabbarInfo(viewController, selectedImageName: "_i_icon_10978_icon_109781_256", unselectedImageName: "_i_icon_10978_icon_109780_256", title: "検索")
                case .channel:
                    setTabbarInfo(viewController, selectedImageName: "_i_icon_11001_icon_110011_256", unselectedImageName: "_i_icon_11001_icon_110010_256", title: "登録チャンネル")
                case .inbox:
                    setTabbarInfo(viewController, selectedImageName: "_i_icon_11218_icon_112181_256", unselectedImageName: "_i_icon_11218_icon_112180_256", title: "受信トレイ")
                case .library:
                    setTabbarInfo(viewController, selectedImageName: "_i_icon_15408_icon_154081_256", unselectedImageName: "_i_icon_15408_icon_154080_256", title: "ライブラリ")
                }
            }
        })
    }
    
    
    private func setTabbarInfo(_ viewController: UIViewController, selectedImageName: String, unselectedImageName: String, title: String) {
        
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.resize(size: .init(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.image = UIImage(named: unselectedImageName)?.resize(size: .init(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
        
        viewController.tabBarItem.title = title
        
    }
    
}
