//
//  InputsFormViewController.swift
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


class InputsFormViewController : XLFormViewController {

    
    private enum Tags : String {
        case Name = "name"
        case Email = "email"
        case Twitter = "twitter"
        case Number = "number"
        case Integer = "integer"
        case Decimal = "decimal"
        case Password = "password"
        case Phone = "phone"
        case Url = "url"
        case TextView = "textView"
        case Notes = "notes"
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
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("TextField Types")
        section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Name
        row = XLFormRowDescriptor(tag: Tags.Name.rawValue, rowType: XLFormRowDescriptorTypeText, title: "Name")
        row.required = true
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.Email.rawValue, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        // validate the email
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Twitter
        row = XLFormRowDescriptor(tag: Tags.Name.rawValue, rowType: XLFormRowDescriptorTypeTwitter, title: "Twitter")
        row.disabled = NSNumber(bool: true)
        row.value = "@no_editable"
        section.addFormRow(row)
        
        // Number
        row = XLFormRowDescriptor(tag: Tags.Number.rawValue, rowType: XLFormRowDescriptorTypeNumber, title: "Number")
        section.addFormRow(row)
        
        // Integer
        row = XLFormRowDescriptor(tag: Tags.Integer.rawValue, rowType: XLFormRowDescriptorTypeInteger, title: "Integer")
        section.addFormRow(row)
        
        // Decimal
        row = XLFormRowDescriptor(tag: Tags.Decimal.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Decimal")
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.Password.rawValue, rowType: XLFormRowDescriptorTypePassword, title: "Password")
        section.addFormRow(row)
        
        // Phone
        row = XLFormRowDescriptor(tag: Tags.Phone.rawValue, rowType: XLFormRowDescriptorTypePhone, title: "Phone")
        section.addFormRow(row)
        
        // Url
        row = XLFormRowDescriptor(tag: Tags.Url.rawValue, rowType: XLFormRowDescriptorTypeURL, title: "Url")
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        
        // TextView
        row = XLFormRowDescriptor(tag: Tags.TextView.rawValue, rowType: XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "TEXT VIEW EXAMPLE"
        section.addFormRow(row)
        

        section = XLFormSectionDescriptor.formSectionWithTitle("TextView With Label Example")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Number.rawValue, rowType: XLFormRowDescriptorTypeTextView, title: "Notes")
        section.addFormRow(row)
        
        self.form = form
        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
    }
    
    func savePressed(button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first)
            return
        }
        self.tableView.endEditing(true)
        let alertView = UIAlertView(title: "Valid Form", message: "No errors found", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }

}
