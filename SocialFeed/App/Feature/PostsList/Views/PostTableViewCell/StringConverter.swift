//
//  Transformer.swift
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    @objc func applyAttribute(text: String, range: NSRange) {
        let pos = range.location
        let len = range.length
        let fromIdx = text.unicodeScalars.index(text.unicodeScalars.startIndex, offsetBy: pos)
        let toIdx = text.unicodeScalars.index(fromIdx, offsetBy: len)
        let nsRange = NSRange(fromIdx..<toIdx, in: text)

        addAttribute(NSAttributedString.Key.foregroundColor,
                                value: UIColor.red,
                                range: nsRange)
        
    }
}
