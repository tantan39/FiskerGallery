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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 14
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 47)
        label.text = "Create an account".uppercased()
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "F8F9A9")
        return label
    }()
    
    lazy var fullNameTextfield: FKTextfieldView = {
        let fullnameRegex = "^[a-zA-Z]+ [a-zA-Z]+$"
        let textfield = FKTextfieldView(validationRegex: fullnameRegex)
        textfield.addTarget(self, action: #selector(fullNameTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Full Name"
        textfield.textColor = .white
        return textfield
    }()
    
    lazy var mobileTextfield: FKTextfieldView = {
        let mobileRegex = "^([1-9]{1})[0-9]{9}$"
        let textfield = FKTextfieldView(validationRegex: mobileRegex)
        textfield.addTarget(self, action: #selector(mobileTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Mobile"
        textfield.textColor = .white
        return textfield
    }()
    
    lazy var emailTextfield: FKTextfieldView = {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let textfield = FKTextfieldView(validationRegex: emailRegEx)
        textfield.addTarget(self, action: #selector(emailTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Email Address"
        textfield.textColor = .white
        return textfield
    }()
    
    lazy var countryTextfield: FKTextfieldView = {
        let textfield = FKTextfieldView()
        textfield.addTarget(self, action: #selector(countryTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Country or Region"
        textfield.textColor = .white
        return textfield
    }()
    
    lazy var zipcodeTextfield: FKTextfieldView = {
        let zipcodeRegex = "^[0-9]+$"
        let textfield = FKTextfieldView(validationRegex: zipcodeRegex)
        textfield.addTarget(self, action: #selector(zipcodeTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Zip or Postal Code"
        textfield.textColor = .white
        return textfield
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next".uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 26)
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
        self.view.backgroundColor = UIColor(hex: "0992B5")
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnBackgroundView)))
        
        setupTitleLabel()
        setupStackView()
        setupFullNameTextfield()
        setupMobileTextfield()
        setupEmailTextfield()
        setupCountryTextfield()
        setupZipcodeTextfield()
        setupNextButton()
    }
    
    private func binding() {
        self.viewModel?.isValidating.sink(receiveValue: { value in
            self.nextButton.isEnabled = value
            self.nextButton.backgroundColor = value ? UIColor(hex: "153052") : .gray

        }).store(in: &cancellables)
    }
    
    func setupTitleLabel() {
        self.view.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontal)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontal)
            maker.top.equalToSuperview().offset(150)
        }
    }
    
    func setupStackView() {
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.normalHorizontal)
            make.leading.equalToSuperview().offset(Dimension.shared.mediumHorizontal)
            make.trailing.equalToSuperview().offset(-Dimension.shared.mediumHorizontal)
        }
    }
    
    private func setupFullNameTextfield() {
        self.stackView.addArrangedSubview(fullNameTextfield)
        fullNameTextfield.snp.makeConstraints { maker in
            maker.height.equalTo(Dimension.shared.textfieldHeight)
        }
    }
    
    private func setupMobileTextfield() {
        self.stackView.addArrangedSubview(mobileTextfield)
        mobileTextfield.snp.makeConstraints { maker in
            maker.height.equalTo(fullNameTextfield)
        }
    }
    
    private func setupEmailTextfield() {
        self.stackView.addArrangedSubview(emailTextfield)
        emailTextfield.snp.makeConstraints { maker in
            maker.height.equalTo(fullNameTextfield)
        }
    }
    
    fileprivate func setupCountryTextfield() {
        self.stackView.addArrangedSubview(countryTextfield)
        countryTextfield.snp.makeConstraints { maker in
            maker.height.equalTo(fullNameTextfield)
        }
    }
    
    private func setupZipcodeTextfield() {
        self.stackView.addArrangedSubview(zipcodeTextfield)
        zipcodeTextfield.snp.makeConstraints { maker in
            maker.height.equalTo(fullNameTextfield)
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setupNextButton() {
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.stackView.snp.bottom).offset(Dimension.shared.normalHorizontal)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontal29)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontal29)
            maker.height.equalTo(Dimension.shared.buttonHeight)
        }
    }
    
    @IBAction func fullNameTextfieldEditingChanged() {
        self.viewModel?.fullName = fullNameTextfield.text
        self.fullNameTextfield.validate()
    }
    
    @IBAction func mobileTextfieldEditingChanged() {
        self.viewModel?.mobile = mobileTextfield.text
        self.mobileTextfield.validate()
    }
    
    @IBAction func emailTextfieldEditingChanged() {
        self.viewModel?.email = emailTextfield.text
        self.emailTextfield.validate()
    }
    
    @IBAction func countryTextfieldEditingChanged() {
        self.viewModel?.country = countryTextfield.text
        self.countryTextfield.validate()
    }
    
    @IBAction func zipcodeTextfieldEditingChanged() {
        self.viewModel?.zipcode = zipcodeTextfield.text
        self.zipcodeTextfield.validate()
    }
    
    @IBAction func tapOnBackgroundView() {
        self.view.endEditing(true)
    }
}
