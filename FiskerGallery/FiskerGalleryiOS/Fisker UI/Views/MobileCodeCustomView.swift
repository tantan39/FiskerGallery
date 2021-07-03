//
//  MobileCodeCustomView.swift
//  FiskerGallery
//
//  Created by Tan Tan on 7/3/21.
//

import UIKit
import Combine

class MobileCodeViewModel {
    var selectedCode = PassthroughSubject<String?, Never>()
    @Published var codes: [String] = ["+1", "+44"]
}

class MobileCodeCustomView: UIView {
    lazy var mobileCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("+1", for: .normal)
        button.setTitleColor(UIColor(hex: "153052"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    lazy var dropDrownIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-dropdown")
        imageView.contentMode = .left
        return imageView
    }()
    
    private var parentView: UIViewController?
    private var viewModel: MobileCodeViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    convenience init(_ parentView: UIViewController?, viewModel: MobileCodeViewModel) {
        self.init(frame: .zero)
        
        self.parentView = parentView
        self.viewModel = viewModel
        setupUI()
        binding()
        mobileCodeButton.addTarget(self, action: #selector(codeButtonPressed(_:)), for: .touchUpInside)
    }
    
    func setupUI() {
        setupMobileCodeButton()
        setupDropdownIcon()
    }
    
    private func binding() {
        self.viewModel?.selectedCode.sink(receiveValue: { [weak self] code in
            guard let self = self else { return }
            self.mobileCodeButton.setTitle(code, for: .normal)
        }).store(in: &cancellables)
        
    }
    
    private func setupMobileCodeButton() {
        self.addSubview(mobileCodeButton)
        self.mobileCodeButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.height.equalToSuperview()
            maker.width.equalTo(35)
        }
    }
    
    private func setupDropdownIcon() {
        self.addSubview(dropDrownIcon)
        dropDrownIcon.snp.makeConstraints { maker in
            maker.leading.equalTo(mobileCodeButton.snp.trailing)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(9)
            maker.trailing.equalToSuperview().offset(-2)
        }
    }
    
    @IBAction func codeButtonPressed(_ sender: UIButton) {
        showPhoneCodePickerView()
    }
    
    private func showPhoneCodePickerView() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let codes = self.viewModel?.codes {
            for (_, element) in codes.enumerated() {
                optionMenu.addAction(UIAlertAction(title: element, style: .default, handler: { [weak self ] value in
                    guard let self = self else { return }
                    self.viewModel?.selectedCode.send(element)
                }))
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            optionMenu.addAction(cancelAction)
            
            self.parentView?.present(optionMenu, animated: true)
        }
    }
}
