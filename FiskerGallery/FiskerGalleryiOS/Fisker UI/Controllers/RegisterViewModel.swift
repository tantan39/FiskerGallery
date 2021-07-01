//
//  RegisterViewModel.swift
//  FiskerGalleryiOS
//
//  Created by Tan Tan on 7/1/21.
//

import Foundation

public struct RegisterViewModel {
    public init() { }
    
    public var isValidated: Bool {
        guard let name = fullName, let mobile = mobile, let email = email, let country = country, let zipcode = zipcode else { return false }
        return !name.isEmpty && !mobile.isEmpty && !email.isEmpty && !country.isEmpty && !zipcode.isEmpty
    }
    
    public var fullName: String?
    public var mobile: String?
    public var email: String?
    public var country: String?
    public var zipcode: String?
}
