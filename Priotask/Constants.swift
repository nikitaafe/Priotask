//
//  Constants.swift
//  Priotask
//
//  Created by Nikita Felicia on 26/04/22.
//

import UIKit

struct Constants {
    
    static var hasTopNotch: Bool {
        guard #available(iOS 15, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        return window.safeAreaInsets.top >= 44
    }
}
