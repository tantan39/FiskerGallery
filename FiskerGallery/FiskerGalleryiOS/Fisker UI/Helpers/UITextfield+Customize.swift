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
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = color
        borderStyle = .none
        self.addSubview(bottomLine)
        NSLayoutConstraint.activate([
            bottomLine.topAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
}
