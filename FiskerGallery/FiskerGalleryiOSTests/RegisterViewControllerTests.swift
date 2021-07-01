//
//  RegisterViewControllerTests.swift
//  FiskerGalleryiOSTests
//
//  Created by Tan Tan on 7/1/21.
//

import XCTest

struct RegisterViewModel {
    var isValidated: Bool {
        guard let name = fullName, let mobile = mobile, let email = email, let country = country, let zipcode = zipcode else { return false }
        return !name.isEmpty && !mobile.isEmpty && !email.isEmpty && !country.isEmpty && !zipcode.isEmpty
    }
    
    var fullName: String?
    var mobile: String?
    var email: String?
    var country: String?
    var zipcode: String?
}

class RegisterViewController: UIViewController {
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
    
    convenience init(viewModel: RegisterViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
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

class RegisterViewControllerTests: XCTestCase {
    func test_init_NotValidated() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.viewModel?.isValidated, false)
    }
    
    func test_register_requireFieldsNotEmpty() {
        let sut = makeSUT()
        let window = UIWindow()
        window.addSubview(sut.view)
        sut.loadViewIfNeeded()
        
        sut.simulateFullNameInput()
        sut.simulateMobileInput()
        sut.simulateEmailInput()
        sut.simulateCountryInput()
        sut.simulateZipCodeInput()
        
        XCTAssertEqual(sut.viewModel?.fullName?.isEmpty, false)
        XCTAssertEqual(sut.viewModel?.mobile?.isEmpty, false)
        XCTAssertEqual(sut.viewModel?.email?.isEmpty, false)
        XCTAssertEqual(sut.viewModel?.country?.isEmpty, false)
        XCTAssertEqual(sut.viewModel?.zipcode?.isEmpty, false)
        XCTAssertEqual(sut.viewModel?.isValidated, true)
    }
    
    // MARK: - Helpers
    func makeSUT() -> RegisterViewController {
        let viewModel = RegisterViewModel()
        let sut = RegisterViewController(viewModel: viewModel)
        
        return sut
    }
}
