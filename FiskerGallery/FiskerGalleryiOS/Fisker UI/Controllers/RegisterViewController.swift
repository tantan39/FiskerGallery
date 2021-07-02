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
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 48)
        label.text = "Create an account".uppercased()
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "F8F9A9")
        return label
    }()
    
    lazy var fullNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(fullNameTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Full Name"
        return textfield
    }()
    
    lazy var mobileTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(mobileTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Mobile"
        return textfield
    }()
    
    lazy var emailTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(emailTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Email Address"
        return textfield
    }()
    
    lazy var countryTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(countryTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Country or Region"
        return textfield
    }()
    
    lazy var zipcodeTextfield: UITextField = {
        let textfield = UITextField()
        textfield.addTarget(self, action: #selector(zipcodeTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Zip or Postal Code"
        return textfield
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle("Next".uppercased(), for: .normal)
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
        self.viewModel?.isValidating.assign(to: \.isEnabled, on: self.nextButton)
            .store(in: &cancellables)
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
            make.leading.trailing.equalTo(titleLabel)
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
