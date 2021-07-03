//
//  RegisterViewController+TestHelpers.swift
//  FiskerGalleryiOSTests
//
//  Created by Tan Tan on 7/1/21.
//

import Foundation
@testable import FiskerGalleryiOS
extension RegisterViewController {
    func simulateFullNameInput() {
        fullNameTextfield.text = "user fullname"
        fullNameTextfield.textfield.simulate(event: .editingChanged)
    }
    
    func simulateMobileInput() {
        mobileTextfield.text = "2042456125"
        mobileTextfield.textfield.simulate(event: .editingChanged)
    }
    
    func simulateEmailInput() {
        emailTextfield.text = "email@gmail.com"
        emailTextfield.textfield.simulate(event: .editingChanged)
    }
    
    func simulateCountryInput() {
        countryTextfield.text = "US"
        countryTextfield.textfield.simulate(event: .editingChanged)
    }
    
    func simulateZipCodeInput() {
        zipcodeTextfield.text = "23112"
        zipcodeTextfield.textfield.simulate(event: .editingChanged)
    }
}
