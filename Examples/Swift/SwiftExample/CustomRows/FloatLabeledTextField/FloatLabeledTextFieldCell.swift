//  FloatLabeledTextFieldCell.swift
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014-2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


let XLFormRowDescriptorTypeFloatLabeledTextField = "XLFormRowDescriptorTypeFloatLabeledTextField"


class FloatLabeledTextFieldCell : XLFormBaseCell, UITextFieldDelegate {
    
    static let kFontSize : CGFloat = 16.0
    
    
    lazy var floatLabeledTextField: JVFloatLabeledTextField  = {
        let result  = JVFloatLabeledTextField(frame: CGRect.zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: kFontSize)
        result.floatingLabel.font = .boldSystemFont(ofSize: kFontSize)
        result.clearButtonMode = .whileEditing
        return result
    }()

//Mark: - XLFormDescriptorCell
    
    override func configure() {
        super.configure()
        selectionStyle = .none
        contentView.addSubview(self.floatLabeledTextField)
        floatLabeledTextField.delegate = self
        contentView.addConstraints(layoutConstraints())
    }
    
    override func update() {
        super.update()
        if let rowDescriptor = rowDescriptor {
            floatLabeledTextField.attributedPlaceholder = NSAttributedString(string: rowDescriptor.title ?? "" , attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            if let value = rowDescriptor.value {
                floatLabeledTextField.text = (value as AnyObject).displayText()
            }
            else {
                floatLabeledTextField.text = rowDescriptor.noValueDisplayText
            }
            floatLabeledTextField.isEnabled = !rowDescriptor.isDisabled()
            floatLabeledTextField.floatingLabelTextColor = .lightGray
            floatLabeledTextField.alpha = rowDescriptor.isDisabled() ? 0.6 : 1.0
        }
    }
    
    override func formDescriptorCellCanBecomeFirstResponder() -> Bool {
        return rowDescriptor?.isDisabled() == false
    }
    
    
    override func formDescriptorCellBecomeFirstResponder() -> Bool {
        return self.floatLabeledTextField.becomeFirstResponder()
    }
    
    override static func formDescriptorCellHeight(for rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 55.0
    }
    
    
//MARK: Helpers
    
    func layoutConstraints() -> [NSLayoutConstraint]{
        let views = ["floatLabeledTextField" : floatLabeledTextField]
        let metrics = ["hMargin": 15.0, "vMargin": 8.0]
        var result =  NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hMargin)-[floatLabeledTextField]-(hMargin)-|", options:.alignAllCenterY, metrics:metrics, views:views)
        result += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|", options:.alignAllCenterX, metrics:metrics, views:views)
        return result
    }

    func textFieldDidChange(_ textField : UITextField) {
        if floatLabeledTextField == textField {
            if let rowDescriptor = rowDescriptor, let text = self.floatLabeledTextField.text {
                if text.isEmpty == false {
                    rowDescriptor.value = self.floatLabeledTextField.text
                } else {
                    rowDescriptor.value = nil
                }
            }
        }
    }

//Mark: UITextFieldDelegate
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldClear(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldReturn(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldBeginEditing(textField)
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldEndEditing(textField)
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.formViewController().textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.formViewController().textFieldDidBeginEditing(textField)
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldDidChange(textField)
        self.formViewController().textFieldDidEndEditing(textField)
    }
    
}
