//
//  RegisterViewController.swift
//  FiskerGalleryiOS
//
//  Created by Tan Tan on 7/1/21.
//

import UIKit
import Combine
import SVProgressHUD

public class RegisterViewController: UIViewController {
    var viewModel: RegisterViewModel?
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
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
        let textfield = FKTextfieldView(validationRegex: fullnameRegex, validationMessage: "Please enter a valid full name")
        textfield.addTarget(self, action: #selector(fullNameTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Full Name"
        textfield.textColor = .white
        return textfield
    }()
    
    lazy var mobileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top
        return stackView
    }()
    
    lazy var mobileCodeCustomView: MobileCodeCustomView = {
        let view = MobileCodeCustomView(self, viewModel: mobileCodeViewModel)
        return view
    }()
    
    lazy var mobileTextfield: FKTextfieldView = {
        let mobileRegex = "^([1-9]{1})[0-9]{9}$"
        let textfield = FKTextfieldView(validationRegex: mobileRegex, validationMessage: "Please enter a valid phone number")
        textfield.addTarget(self, action: #selector(mobileTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Mobile"
        textfield.textColor = .white
        textfield.keyboardType = .phonePad
        return textfield
    }()
    
    lazy var emailTextfield: FKTextfieldView = {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let textfield = FKTextfieldView(validationRegex: emailRegEx, validationMessage: "Please enter a valid email")
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
        textfield.textfield.inputView = countryPickerView
        textfield.tintColor = .clear
        return textfield
    }()
    
    lazy var zipcodeTextfield: FKTextfieldView = {
        let zipcodeRegex = "^[0-9]+$"
        let textfield = FKTextfieldView(validationRegex: zipcodeRegex, validationMessage: "Please enter a valid zip code")
        textfield.addTarget(self, action: #selector(zipcodeTextfieldEditingChanged), for: .editingChanged)
        textfield.placeholder = "Zip or Postal Code"
        textfield.textColor = .white
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    lazy var privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "By clicking “Next” you agree to Fisker’s Terms of Use and Privacy Policy agreement."
        label.font = UIFont(name: "Helvetica", size: 11)
        label.textColor = .white
        label.alpha = 0.5
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next".uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 26)
        button.addTarget(self, action: #selector(nextButton_Pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 11)
        let attributeString = NSMutableAttributedString()
        let haveAnAccount = NSAttributedString(string: "Have an Account? ", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 14)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        
        let logIn = NSAttributedString(string: "Log In", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Helvetica-bold", size: 14)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        attributeString.append(haveAnAccount)
        attributeString.append(logIn)
        label.attributedText = attributeString
        label.textAlignment = .center
        return label
    }()
    
    lazy var textRatesLabel: UILabel = {
        let label = UILabel()
        label.text = "Standard text message rates apply."
        label.font = UIFont(name: "Helvetica", size: 11)
        label.textColor = .white
        label.alpha = 0.5
        label.textAlignment = .center
        return label
    }()
    
    lazy var countryPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private let mobileCodeViewModel = MobileCodeViewModel()
    
    public convenience init(viewModel: RegisterViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        binding()
        registerNotifications()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(hex: "0992B5")
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnBackgroundView)))
        
        setupTitleLabel()
        setupStackView()
        setupFullNameTextfield()
        setupMobileStackView()
        setupMobileCodeView()
        setupMobileTextfield()
        setupEmailTextfield()
        setupCountryTextfield()
        setupZipcodeTextfield()
        setupPrivacyLabel()
        setupNextButton()
        setupSignInLabel()
        setupTextRatesLabel()
    }
    
    private func binding() {
        self.viewModel?.isValidating.sink(receiveValue: { [weak self] value in
            guard let self = self else { return }
            self.nextButton.isEnabled = value
            self.nextButton.backgroundColor = value ? UIColor(hex: "153052") : .gray

        }).store(in: &cancellables)
        
        self.viewModel?.isLoading.sink(receiveValue: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }).store(in: &cancellables)
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    func setupTitleLabel() {
        self.view.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontal)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontal)
            maker.top.equalToSuperview().offset(100)
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
    
    private func setupMobileStackView() {
        self.stackView.addArrangedSubview(mobileStackView)
    }
    
    private func setupMobileCodeView() {
        self.mobileStackView.addArrangedSubview(mobileCodeCustomView)
        
        let spacing = UIView()
        self.mobileStackView.addArrangedSubview(spacing)
        spacing.snp.makeConstraints { maker in
            maker.width.equalTo(16)
        }
    }
    
    private func setupMobileTextfield() {
        self.mobileStackView.addArrangedSubview(mobileTextfield)
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
    
    private func setupPrivacyLabel() {
        self.view.addSubview(self.privacyLabel)
        self.privacyLabel.snp.makeConstraints { maker in
            maker.top.equalTo(stackView.snp.bottom).offset(Dimension.shared.normalVertical40)
            maker.leading.equalToSuperview().offset(Dimension.shared.largeHorizontal)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.largeHorizontal)
        }
    }
    
    private func setupNextButton() {
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.privacyLabel.snp.bottom).offset(Dimension.shared.mediumVertical)
            maker.leading.equalToSuperview().offset(Dimension.shared.normalHorizontal29)
            maker.trailing.equalToSuperview().offset(-Dimension.shared.normalHorizontal29)
            maker.height.equalTo(Dimension.shared.buttonHeight)
        }
    }
    
    private func setupSignInLabel() {
        self.view.addSubview(self.signInLabel)
        self.signInLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nextButton.snp.bottom).offset(Dimension.shared.mediumVertical)
            maker.centerX.equalTo(nextButton)
        }
    }
    
    private func setupTextRatesLabel() {
        self.view.addSubview(self.textRatesLabel)
        self.textRatesLabel.snp.makeConstraints { maker in
            maker.top.equalTo(signInLabel.snp.bottom).offset(34)
            maker.centerX.equalTo(signInLabel)
        }
    }
    
    @IBAction func fullNameTextfieldEditingChanged() {
        self.viewModel?.fullName = fullNameTextfield.text
        self.viewModel?.fullNameValidate.send(self.fullNameTextfield.validate())
    }
    
    @IBAction func mobileTextfieldEditingChanged() {
        self.viewModel?.mobile = mobileTextfield.text
        self.viewModel?.mobileValidate.send(self.mobileTextfield.validate())
    }
    
    @IBAction func emailTextfieldEditingChanged() {
        self.viewModel?.email = emailTextfield.text
        self.viewModel?.emailValidate.send(self.emailTextfield.validate())
    }
    
    @IBAction func countryTextfieldEditingChanged() {
        self.viewModel?.country = countryTextfield.text
        self.viewModel?.countryValidate.send(self.countryTextfield.validate())
    }
    
    @IBAction func zipcodeTextfieldEditingChanged() {
        self.viewModel?.zipcode = zipcodeTextfield.text
        self.viewModel?.zipCodeValidate.send(self.zipcodeTextfield.validate())
    }
    
    @IBAction func tapOnBackgroundView() {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButton_Pressed() {
        self.viewModel?.register {
            let alert = UIAlertController(title: nil, message: "Register successfully", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension RegisterViewController {
    @objc private func keyboardWillShow(notification: Notification) {
        guard zipcodeTextfield.textfield.isEditing else { return }
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let zipcodeFrame = stackView.convert(zipcodeTextfield.frame, to: self.view)
        let overlappedHeight = keyboardRectangle.origin.y - zipcodeFrame.maxY

        guard (overlappedHeight < 0) else { return }
        UIView.animate(withDuration: 0.35) {
            self.view.transform = CGAffineTransform(translationX: 0, y: overlappedHeight-15)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard zipcodeTextfield.textfield.isEditing else { return }

        UIView.animate(withDuration: 0.35) {
            self.view.transform = CGAffineTransform.identity
        }
    }
}
