//
//  Enums.swift
//  Priotask
//
//  Created by Nikita Felicia on 27/04/22.
//

import Foundation
import UIKit

enum Animations {
    case easeInBackgroundColor
    case blinkReverse
    case easeInOpacity
    
    func animateView(view: UIView, color: UIColor = UIColor.white){
        switch self {
        case .easeInBackgroundColor:
            UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseIn, animations: {
                view.backgroundColor = color
            })
            
        case .blinkReverse:
            Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { (Timer) in
                UIView.animate(withDuration: 0.35, delay: 0, options: .autoreverse, animations: {
                    view.layer.opacity = 0
                }) {_ in
                    UIView.animate(withDuration: 0.35, delay: 0, options: .autoreverse) {
                        view.layer.opacity = 1
                    }
                }
            }
        case .easeInOpacity:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                view.layer.opacity = 1
            })
        }
    }
}
