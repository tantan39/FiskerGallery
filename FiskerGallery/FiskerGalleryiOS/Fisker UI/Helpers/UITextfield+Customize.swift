//
//  UITextfield+Customize.swift
//  FiskerGallery
//
//  Created by Tan Tan on 7/2/21.
//

import UIKit

extension UITextField {
    func addBottomBorder(_ color: UIColor? = .white){
        let bottomLine = UIView()
        bottomLine.tag = 999
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = color
        borderStyle = .none
        self.addSubview(bottomLine)
        NSLayoutConstraint.activate([
            bottomLine.topAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    func setBottomLineColor(_ color: UIColor? = .white) {
        let view = self.viewWithTag(999)
        view?.backgroundColor = color
    }
}

extension UITextField {
    func setLeftPadding(_ padding:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
