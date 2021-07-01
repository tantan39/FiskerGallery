//
//  RegisterViewControllerTests.swift
//  FiskerGalleryiOSTests
//
//  Created by Tan Tan on 7/1/21.
//

import XCTest

struct RegisterViewModel {
    var isValidated: Bool {
        guard let name = fullName, let mobile = mobile, let email = email else { return false }
        return !name.isEmpty && !mobile.isEmpty && !email.isEmpty
    }
    
    var fullName: String?
    var mobile: String?
    var email: String?
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
        
        XCTAssertEqual(sut.viewModel?.fullName?.isEmpty, false)
        XCTAssertEqual(sut.viewModel?.mobile?.isEmpty, false)
        XCTAssertEqual(sut.viewModel?.email?.isEmpty, false)
        XCTAssertEqual(sut.viewModel?.isValidated, true)
    }
    
    // MARK: - Helpers
    func makeSUT() -> RegisterViewController {
        let viewModel = RegisterViewModel()
        let sut = RegisterViewController(viewModel: viewModel)
        
        return sut
    }
}
