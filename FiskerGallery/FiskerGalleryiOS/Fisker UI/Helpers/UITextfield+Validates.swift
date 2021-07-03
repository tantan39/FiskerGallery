//
//  UITextfield+Validates.swift
//  FiskerGallery
//
//  Created by Tan Tan on 7/2/21.
//

import UIKit

extension UITextField {
    func validate() {
        guard let value = self.text, !value.isEmpty else {
            self.layer.borderColor = UIColor.red.cgColor
            return
        }
        self.layer.borderColor = UIColor.black.cgColor
    }
}
