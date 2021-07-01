//
//  RegisterViewController.swift
//  FiskerGalleryiOS
//
//  Created by Tan Tan on 7/1/21.
//

import UIKit

public class RegisterViewController: UIViewController {
    public var viewModel: RegisterViewModel?
    
    public lazy var fullNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(fullNameTextfieldEditingChanged), for: .editingChanged)

        return textfield
    }()
    
    public lazy var mobileTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(mobileTextfieldEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    public lazy var emailTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(emailTextfieldEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    public lazy var countryTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(countryTextfieldEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    public lazy var zipcodeTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(zipcodeTextfieldEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    public convenience init(viewModel: RegisterViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(fullNameTextfield)
        self.view.addSubview(mobileTextfield)
        self.view.addSubview(emailTextfield)
        self.view.addSubview(countryTextfield)
        self.view.addSubview(zipcodeTextfield)
    }
    
    @objc
    @IBAction func fullNameTextfieldEditingChanged() {
        self.viewModel?.fullName = fullNameTextfield.text
    }
    
    @objc
    @IBAction func mobileTextfieldEditingChanged() {
        self.viewModel?.mobile = mobileTextfield.text
    }
    
    @objc
    @IBAction func emailTextfieldEditingChanged() {
        self.viewModel?.email = emailTextfield.text
    }
    
    @objc
    @IBAction func countryTextfieldEditingChanged() {
        self.viewModel?.country = countryTextfield.text
    }
    
    @objc
    @IBAction func zipcodeTextfieldEditingChanged() {
        self.viewModel?.zipcode = zipcodeTextfield.text
    }
}
