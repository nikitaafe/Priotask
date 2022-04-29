//
//  FoundationExtensions.swift
//  Priotask
//
//  Created by Nikita Felicia on 26/04/22.
//

import UIKit

extension Int {
    func appendZeroes() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}

extension Double {
    func degreeToRadians() -> CGFloat {
        return CGFloat(self * .pi) / 100
    }
}


extension Int{
    func appendZeros() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
    func degreeToRadians() -> CGFloat {
       return  (CGFloat(self) * .pi) / 180
    }
}


extension Double{
    func toInt() -> Int {
        return Int(self)
    }
}
