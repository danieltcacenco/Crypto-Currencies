//
//  UIView+Extension.swift
//  Crypto-Currencies
//

import UIKit

extension UIView {
    func rounded(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
