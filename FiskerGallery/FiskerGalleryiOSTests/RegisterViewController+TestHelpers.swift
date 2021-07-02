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
        fullNameTextfield.simulate(event: .editingChanged)
    }
    
    func simulateMobileInput() {
        mobileTextfield.text = "2042456125"
        mobileTextfield.simulate(event: .editingChanged)
    }
    
    func simulateEmailInput() {
        emailTextfield.text = "email address"
        emailTextfield.simulate(event: .editingChanged)
    }
    
    func simulateCountryInput() {
        countryTextfield.text = "country or region"
        countryTextfield.simulate(event: .editingChanged)
    }
    
    func simulateZipCodeInput() {
        zipcodeTextfield.text = "23112"
        zipcodeTextfield.simulate(event: .editingChanged)
    }
}
