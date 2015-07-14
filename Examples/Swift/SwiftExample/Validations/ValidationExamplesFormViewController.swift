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

    private enum Tags : String {
        case ValidationName = "Name"
        case ValidationEmail = "Email"
        case ValidationPassword = "Password"
        case ValidationInteger = "Integer"
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
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
        row = XLFormRowDescriptor(tag: Tags.ValidationName.rawValue, rowType: XLFormRowDescriptorTypeText, title:"Name")
        row.cellConfigAtConfigure["textField.placeholder"] = "Required..."
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Right.rawValue
        row.required = true
        row.value = "Martin"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "Validation Email"
        form.addFormSection(section)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail.rawValue, rowType: XLFormRowDescriptorTypeText, title:"Email")
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = false
        row.value = "not valid email"
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor()
        section.title = "Validation Password"
        section.footerTitle = "between 6 and 32 charachers, 1 alphanumeric and 1 numeric"
        form.addFormSection(section)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword.rawValue, rowType: XLFormRowDescriptorTypePassword, title:"Password")
        row.cellConfigAtConfigure["textField.placeholder"] = "Required..."
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "At least 6, max 32 characters", andRegexString: "^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$"))
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor()
        section.title = "Validation Numbers"
        section.footerTitle = "greater than 50 and less than 100"
        form.addFormSection(section)
        
        // Integer
        row = XLFormRowDescriptor(tag: Tags.ValidationInteger.rawValue, rowType:XLFormRowDescriptorTypeInteger, title:"Integer")
        row.cellConfigAtConfigure["textField.placeholder"] = "Required..."
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "greater than 50 and less than 100", andRegexString: "^([5-9][0-9]|100)$"))
        section.addFormRow(row)
        
        self.form = form
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = "validateForm:"
    }
    

    
//MARK: Actions
    
    func validateForm(buttonItem: UIBarButtonItem) {
        let array = self.formValidationErrors()
        for errorItem in array {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo![XLValidationStatusErrorKey] as! XLFormValidationStatus
            if validationStatus.rowDescriptor.tag == Tags.ValidationName.rawValue {
                if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)) {
                    cell.backgroundColor = UIColor.orangeColor()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.backgroundColor = UIColor.whiteColor()
                    })
                }
            }
            else if validationStatus.rowDescriptor.tag == Tags.ValidationEmail.rawValue ||
                    validationStatus.rowDescriptor.tag == Tags.ValidationPassword.rawValue ||
                    validationStatus.rowDescriptor.tag == Tags.ValidationInteger.rawValue {
                if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)) {
                    self.animateCell(cell)
                }
            }
        }
    }
    
    
//MARK: - Helperph
    
    func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }
}
