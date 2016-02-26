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
        result.font = UIFont.systemFontOfSize(kFontSize)
        result.floatingLabel.font = .boldSystemFontOfSize(kFontSize)
        result.clearButtonMode = .WhileEditing
        return result
    }()

//Mark: - XLFormDescriptorCell
    
    override func configure() {
        super.configure()
        selectionStyle = .None
        contentView.addSubview(self.floatLabeledTextField)
        floatLabeledTextField.delegate = self
        contentView.addConstraints(layoutConstraints())
    }
    
    override func update() {
        super.update()
        if let rowDescriptor = rowDescriptor {
            floatLabeledTextField.attributedPlaceholder = NSAttributedString(string: rowDescriptor.title ?? "" , attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            if let value = rowDescriptor.value {
                floatLabeledTextField.text = value.displayText()
            }
            else {
                floatLabeledTextField.text = rowDescriptor.noValueDisplayText
            }
            floatLabeledTextField.enabled = !rowDescriptor.isDisabled()
            floatLabeledTextField.floatingLabelTextColor = .lightGrayColor()
            floatLabeledTextField.alpha = rowDescriptor.isDisabled() ? 0.6 : 1.0
        }
    }
    
    override func formDescriptorCellCanBecomeFirstResponder() -> Bool {
        return rowDescriptor?.isDisabled() == false
    }
    
    
    override func formDescriptorCellBecomeFirstResponder() -> Bool {
        return self.floatLabeledTextField.becomeFirstResponder()
    }
    
    override static func formDescriptorCellHeightForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 55.0
    }
    
    
//MARK: Helpers
    
    func layoutConstraints() -> [NSLayoutConstraint]{
        let views = ["floatLabeledTextField" : floatLabeledTextField]
        let metrics = ["hMargin": 15.0, "vMargin": 8.0]
        var result =  NSLayoutConstraint.constraintsWithVisualFormat("H:|-(hMargin)-[floatLabeledTextField]-(hMargin)-|", options:.AlignAllCenterY, metrics:metrics, views:views)
        result += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|", options:.AlignAllCenterX, metrics:metrics, views:views)
        return result
    }

    func textFieldDidChange(textField : UITextField) {
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
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldClear(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldReturn(textField)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldBeginEditing(textField)
    }
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldEndEditing(textField)
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return self.formViewController().textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.formViewController().textFieldDidBeginEditing(textField)
    }
    

    func textFieldDidEndEditing(textField: UITextField) {
        self.textFieldDidChange(textField)
        self.formViewController().textFieldDidEndEditing(textField)
    }
    
}
