//
//  RoundUILabel.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/12/08.
//

import UIKit
//인터페이스 빌더에서 디자인으로 확인 가능하도록
@IBDesignable
class RoundUILabel : UILabel {
 
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var topInset: CGFloat = 0.0//4.0
    @IBInspectable var bottomInset: CGFloat = 0.0//4.0
    @IBInspectable var leftInset: CGFloat = 0.0//8.0
    @IBInspectable var rightInset: CGFloat = 0.0//8.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
}
