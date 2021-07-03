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
    
    private var firstPubliser: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3($fullName, $mobile, $email)
            .map { name, mobile, email in
            guard let name = name, let phone = mobile, let email = email else {
                return false
            }
            return !name.isEmpty && !phone.isEmpty && !email.isEmpty        }.eraseToAnyPublisher()
    }
    
    private var secondPublisher: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest ($country, $zipcode)
            .map { country, zipcode in
                guard let country = country, let zipcode = zipcode else {
                    return false
                }
                return !country.isEmpty && !zipcode.isEmpty
            }.eraseToAnyPublisher()
    }
    
    var isValidating: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest (firstPubliser, secondPublisher)
            .map { return $0 && $1 }
            .eraseToAnyPublisher()
    }
}
