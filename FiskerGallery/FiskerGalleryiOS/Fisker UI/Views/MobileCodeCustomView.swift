//
//  MobileCodeCustomView.swift
//  FiskerGallery
//
//  Created by Tan Tan on 7/3/21.
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupMobileCodeButton()
        setupDropdownIcon()
    }
    
    private func setupMobileCodeButton() {
        self.addSubview(mobileCodeButton)
        self.mobileCodeButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.height.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    private func setupDropdownIcon() {
        self.addSubview(dropDrownIcon)
        dropDrownIcon.snp.makeConstraints { maker in
            maker.leading.equalTo(mobileCodeButton.snp.trailing)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(9)
        }
    }
}
