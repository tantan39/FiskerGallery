//
//  RegisterViewController+CountryPickerView.swift
//  FiskerGallery
//
//  Created by Tan Tan on 7/3/21.
//

import UIKit

extension RegisterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel?.countries.count ?? 0
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = self.viewModel?.countries[row]
        return country
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = self.viewModel?.countries[row]
        countryTextfield.text = country
        countryTextfieldEditingChanged()
    }
}
