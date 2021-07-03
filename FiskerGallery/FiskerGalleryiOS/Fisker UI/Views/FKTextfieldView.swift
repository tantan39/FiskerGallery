//
//  FKTextfieldView.swift
//  FiskerGallery
//
//  Created by Tan Tan on 7/2/21.
//

import UIKit

class Validation {
    private var regex: String?
    private var message: String?
    
    init(regex: String?, message: String?) {
        self.regex = regex
        self.message = message
    }
    
    func matchesRegex(text: String) -> Bool {
        guard let regex = regex else { return true }
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
}

class FKTextfieldView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.addBottomBorder()
        textfield.font = .systemFont(ofSize: 16)
        textfield.setLeftPadding(5)
        return textfield
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.textColor = validateErrorColor
        label.text = " "
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    var placeholder: String? = nil {
        didSet {
            self.textfield.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

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
    
    private var validation: Validation?
    
    init(validationRegex: String? = nil, validationMessage: String? = nil) {
        super.init(frame: .zero)
        
        setupUI()
        self.validation = Validation(regex: validationRegex, message: validationMessage)
        
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
    
    private func showMessage(_ message: String?) {
        self.messageLabel.isHidden = false
        self.messageLabel.text = message
        self.textfield.setBottomLineColor(.red)
    }
    
    private func hideMessage() {
        self.messageLabel.text = " "
        self.textfield.setBottomLineColor(.white)
    }
    
    func validate() {
        guard let value = textfield.text, !value.isEmpty else {
            showMessage("not empty message")
            return
        }
        
        if let validation = self.validation, !validation.matchesRegex(text: value) {
            showMessage("invalid message")
           return
        }
        
        hideMessage()
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.textfield.addTarget(target, action: action, for: controlEvents)
    }
}
