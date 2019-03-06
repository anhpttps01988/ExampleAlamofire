
import UIKit

class CustomTextField: UITextField {
    override func didMoveToWindow() {
        let leftView = UIView(frame: CGRect(x: 5.0, y: 0.0, width: 10.0, height: 2.0))
        self.leftView = leftView
        self.leftViewMode = .always
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.borderStyle =  UITextField.BorderStyle.none
        self.font = UIFont.systemFont(ofSize: CGFloat(20.0))
        self.autocorrectionType=UITextAutocorrectionType.no
        self.keyboardType=UIKeyboardType.default
        self.returnKeyType=UIReturnKeyType.done
    }
}

class CustomButton: UIButton {
    override func didMoveToWindow() {
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = true
    }
}
