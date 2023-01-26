//
//  UIButton+Favorite.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 27/01/2023.
//

import UIKit

extension UIButton {
    
    class func favoriteButton(target: Any?, action: Selector?) -> Self
    {
        let button = self.init()
        
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .highlighted)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        
        return button
    }
    
}
