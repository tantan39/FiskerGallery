//
//  RegisterViewController.swift
//  FiskerGalleryiOS
//
//  Created by Tan Tan on 7/1/21.
//

import UIKit
import Combine

public class RegisterViewController: UIViewController {
    var viewModel: RegisterViewModel?
    
    lazy var fullNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(fullNameTextfieldEditingChanged), for: .editingChanged)

        return textfield
    }()
    
    lazy var mobileTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(mobileTextfieldEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    lazy var emailTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(emailTextfieldEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    lazy var countryTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(countryTextfieldEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    lazy var zipcodeTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(zipcodeTextfieldEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        return button
    }()
    
    public convenience init(viewModel: RegisterViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        binding()
    }
    
    private func setupUI() {
        setupFullNameTextfield()
        setupMobileTextfield()
        setupEmailTextfield()
        setupCountryTextfield()
        setupZipcodeTextfield()
        setupNextButton()
    }
    
    private func binding() {
        self.viewModel?.isValidating.assign(to: \.isEnabled, on: self.nextButton)
            .store(in: &cancellables)
    }
    
    private func setupFullNameTextfield() {
        self.view.addSubview(fullNameTextfield)
    }
    
    private func setupMobileTextfield() {
        self.view.addSubview(mobileTextfield)
    }
    
    private func setupEmailTextfield() {
        self.view.addSubview(emailTextfield)
    }
    
    fileprivate func setupCountryTextfield() {
        self.view.addSubview(countryTextfield)
    }
    
    private func setupZipcodeTextfield() {
        self.view.addSubview(zipcodeTextfield)
    }
    
    private func setupNextButton() {
        self.view.addSubview(nextButton)
    }
    
    @IBAction func fullNameTextfieldEditingChanged() {
        self.viewModel?.fullName = fullNameTextfield.text
    }
    
    @IBAction func mobileTextfieldEditingChanged() {
        self.viewModel?.mobile = mobileTextfield.text
    }
    
    @IBAction func emailTextfieldEditingChanged() {
        self.viewModel?.email = emailTextfield.text
    }
    
    @IBAction func countryTextfieldEditingChanged() {
        self.viewModel?.country = countryTextfield.text
    }
    
    @IBAction func zipcodeTextfieldEditingChanged() {
        self.viewModel?.zipcode = zipcodeTextfield.text
    }
}
