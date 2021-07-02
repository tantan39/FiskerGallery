//
//  RegisterViewControllerTests.swift
//  FiskerGalleryiOSTests
//
//  Created by Tan Tan on 7/1/21.
//

import XCTest
import Combine

class RegisterViewControllerTests: XCTestCase {
    var cancellabels = Set<AnyCancellable>()
    
    func test_init_NotValidated() {
        let sut = makeSUT()
                
        sut.viewModel?.isValidating.sink(receiveValue: {
            XCTAssertEqual($0, false)
        }).store(in: &cancellabels)
        
    }
    
    func test_register_requireFieldsNotEmpty() {
        let sut = makeSUT()
        let window = UIWindow()
        window.addSubview(sut.view)
        sut.loadViewIfNeeded()
        
        _ = sut.viewModel?.isValidating.sink(receiveValue: {
            XCTAssertEqual($0, false)
            XCTAssertEqual(sut.nextButton.isEnabled, $0)
        })
        
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
        
        _ = sut.viewModel?.isValidating.sink(receiveValue: {
            XCTAssertEqual($0, true)
            XCTAssertEqual(sut.nextButton.isEnabled, $0)
        })
        
    }
    
    // MARK: - Helpers
    func makeSUT() -> RegisterViewController {
        let viewModel = RegisterViewModel()
        let sut = RegisterViewController(viewModel: viewModel)
        
        return sut
    }
}
