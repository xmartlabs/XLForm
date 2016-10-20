//
//  ValidationExamplesFormViewController.swift
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


class ValidationExamplesFormViewController : XLFormViewController {

    fileprivate struct Tags {
        static let ValidationName = "Name"
        static let ValidationEmail = "Email"
        static let ValidationPassword = "Password"
        static let ValidationInteger = "Integer"
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Text Fields")
        
        section = XLFormSectionDescriptor()
        section.title = "Validation Required"
        form.addFormSection(section)
        
        
        // Name
        row = XLFormRowDescriptor(tag: Tags.ValidationName, rowType: XLFormRowDescriptorTypeText, title:"Name")
        row.cellConfigAtConfigure["textField.placeholder"] = "Required..."
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        row.isRequired = true
        row.value = "Martin"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "Validation Email"
        form.addFormSection(section)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeText, title:"Email")
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.right.rawValue
        row.isRequired = false
        row.value = "not valid email"
        row.addValidator(XLFormValidator.email())
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor()
        section.title = "Validation Password"
        section.footerTitle = "between 6 and 32 charachers, 1 alphanumeric and 1 numeric"
        form.addFormSection(section)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypePassword, title:"Password")
        row.cellConfigAtConfigure["textField.placeholder"] = "Required..."
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.right.rawValue
        row.isRequired = true
        row.addValidator(XLFormRegexValidator(msg: "At least 6, max 32 characters", andRegexString: "^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$"))
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor()
        section.title = "Validation Numbers"
        section.footerTitle = "greater than 50 and less than 100"
        form.addFormSection(section)
        
        // Integer
        row = XLFormRowDescriptor(tag: Tags.ValidationInteger, rowType:XLFormRowDescriptorTypeInteger, title:"Integer")
        row.cellConfigAtConfigure["textField.placeholder"] = "Required..."
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.right.rawValue
        row.isRequired = true
        row.addValidator(XLFormRegexValidator(msg: "greater than 50 and less than 100", andRegexString: "^([5-9][0-9]|100)$"))
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(ValidationExamplesFormViewController.validateForm(_:))
    }
    

    
//MARK: Actions
    
    func validateForm(_ buttonItem: UIBarButtonItem) {
        let array = formValidationErrors()
        for errorItem in array! {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
            if validationStatus.rowDescriptor!.tag == Tags.ValidationName {
                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPath(ofFormRow: rowDescriptor), let cell = tableView.cellForRow(at: indexPath) {
                    cell.backgroundColor = .orange
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.backgroundColor = .white
                    })
                }
            }
            else if validationStatus.rowDescriptor!.tag == Tags.ValidationEmail ||
                    validationStatus.rowDescriptor!.tag == Tags.ValidationPassword ||
                    validationStatus.rowDescriptor!.tag == Tags.ValidationInteger {
                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPath(ofFormRow: rowDescriptor), let cell = tableView.cellForRow(at: indexPath) {
                    self.animateCell(cell)
                }
            }
        }
    }
    
    
//MARK: - Helperph
    
    func animateCell(_ cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, NSNumber(value: 1 / 6.0), NSNumber(value: 3 / 6.0), NSNumber(value: 5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.isAdditive = true
        cell.layer.add(animation, forKey: "shake")
    }
}
