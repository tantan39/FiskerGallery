//
//  FKTextfieldView.swift
//  FiskerGallery
//
//  Created by Tan Tan on 7/2/21.
//

import UIKit

class FKTextfieldView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.addBottomBorder()
        return textfield
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        return label
    }()
    
    var placeholder: String? = nil {
        didSet {
            self.textfield.placeholder = placeholder
        }
    }
    
    var validateErrorColor: UIColor = .red {
        didSet {
            self.messageLabel.textColor = validateErrorColor
        }
    }
    
    var text: String? {
        set { textfield.text = newValue }
        get { return textfield.text }
    }
    
    var textColor: UIColor = .white {
        didSet {
            self.textfield.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupStackView()
        setupTextfield()
        setupMessageLabel()
    }
    
    private func setupStackView() {
        self.addSubview(stackView)
        self.stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupTextfield() {
        stackView.addArrangedSubview(textfield)
    }
    
    private func setupMessageLabel() {
        stackView.addArrangedSubview(messageLabel)
    }
    
    func showMessage(_ message: String?) {
        self.messageLabel.isHidden = false
        self.messageLabel.text = message
    }
    
    func hideMessage() {
        self.messageLabel.isHidden = false
    }
    
    func validate() {
        self.textfield.validate()
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.textfield.addTarget(target, action: action, for: controlEvents)
    }
}
