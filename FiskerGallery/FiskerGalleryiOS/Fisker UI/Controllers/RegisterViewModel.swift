//
//  RegisterViewModel.swift
//  FiskerGalleryiOS
//
//  Created by Tan Tan on 7/1/21.
//

import Foundation
import Combine

public class RegisterViewModel {
    public init() { }
    
    @Published public var fullName: String?
    @Published public var mobile: String?
    @Published public var email: String?
    @Published public var country: String?
    @Published public var zipcode: String?
    @Published public var countries: [String] = ["US", "UK", "Canada", "Germany"]
    
    let fullNameValidate = CurrentValueSubject<Bool, Never>(false)
    let mobileValidate = CurrentValueSubject<Bool, Never>(false)
    let emailValidate = CurrentValueSubject<Bool, Never>(false)
    let countryValidate = CurrentValueSubject<Bool, Never>(false)
    let zipCodeValidate = CurrentValueSubject<Bool, Never>(false)
    let isLoading = CurrentValueSubject<Bool,Never>(false)
    
    private var firstPubliser: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(fullNameValidate, mobileValidate, emailValidate)
            .map { name, mobile, email in
                return name && mobile && email
            }.eraseToAnyPublisher()
    }
    
    private var secondPublisher: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest (countryValidate, zipCodeValidate)
            .map { country, zipcode in
                return country && zipcode
            }.eraseToAnyPublisher()
    }
    
    var isValidating: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest (firstPubliser, secondPublisher)
            .map { return $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func register(_ completion: @escaping () -> Void) {
        self.isLoading.send(true)
        DispatchQueue(label: "com.fisker.queue").asyncAfter(deadline: DispatchTime.now() + 2) {
            self.isLoading.send(false)
            completion()
        }
        
    }
}
