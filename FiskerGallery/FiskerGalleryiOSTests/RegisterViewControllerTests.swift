//
//  RegisterViewControllerTests.swift
//  FiskerGalleryiOSTests
//
//  Created by Tan Tan on 7/1/21.
//

import XCTest

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
