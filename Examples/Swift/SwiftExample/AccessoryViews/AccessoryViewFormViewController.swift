//
//  AccessoryViewFormViewController.swift
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



class AccessoryViewFormViewController : XLFormViewController {


    private enum Tags : String {
        case AccessoryViewRowNavigationEnabled = "RowNavigationEnabled"
        case AccessoryViewRowNavigationShowAccessoryView     = "RowNavigationShowAccessoryView"
        case AccessoryViewRowNavigationStopDisableRow        = "rowNavigationStopDisableRow"
        case AccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow = "rowNavigationSkipCanNotBecomeFirstResponderRow"
        case AccessoryViewRowNavigationStopInlineRow = "rowNavigationStopInlineRow"
        case AccessoryViewName = "name"
        case AccessoryViewEmail = "email"
        case AccessoryViewTwitter = "twitter"
        case AccessoryViewUrl = "url"
        case AccessoryViewDate = "date"
        case AccessoryViewTextView = "textView"
        case AccessoryViewCheck = "check"
        case AccessoryViewNotes = "notes"
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }

    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Accessory View")
        form.rowNavigationOptions = XLFormRowNavigationOptions.Enabled
    
        // Configuration section
        section = XLFormSectionDescriptor()
        section.title = "Row Navigation Settings"
        section.footerTitle = "Changing the Settings values you will navigate differently"
        form.addFormSection(section)
    
        // RowNavigationEnabled
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationEnabled.rawValue, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Row Navigation Enabled?")
        row.value = true
        section.addFormRow(row)
    
        // RowNavigationShowAccessoryView
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationShowAccessoryView.rawValue, rowType:XLFormRowDescriptorTypeBooleanCheck, title:"Show input accessory row?")
        row.value = form.rowNavigationOptions.contains(XLFormRowNavigationOptions.Enabled)
        row.hidden = "$\(Tags.AccessoryViewRowNavigationEnabled.rawValue) == 0"
        section.addFormRow(row)

        // RowNavigationStopDisableRow
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationStopDisableRow.rawValue, rowType: XLFormRowDescriptorTypeBooleanCheck, title:"Stop when reach disabled row?")
        row.value = form.rowNavigationOptions.contains(XLFormRowNavigationOptions.StopDisableRow)
        row.hidden = "$\(Tags.AccessoryViewRowNavigationEnabled.rawValue) == 0"
        section.addFormRow(row)
    
        // RowNavigationStopInlineRow
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationStopInlineRow.rawValue, rowType: XLFormRowDescriptorTypeBooleanCheck, title: "Stop when reach inline row?")
        row.value = form.rowNavigationOptions.contains(XLFormRowNavigationOptions.StopInlineRow)
        row.hidden = "$\(Tags.AccessoryViewRowNavigationEnabled.rawValue) == 0"
        section.addFormRow(row)
        
        // RowNavigationSkipCanNotBecomeFirstResponderRow
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow.rawValue, rowType:XLFormRowDescriptorTypeBooleanCheck, title:"Skip Can Not Become First Responder Row?")
        row.value = form.rowNavigationOptions.contains(XLFormRowNavigationOptions.SkipCanNotBecomeFirstResponderRow)
        row.hidden = "$\(Tags.AccessoryViewRowNavigationEnabled.rawValue) == 0"
        section.addFormRow(row)
        
        
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        
        // Name
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewName.rawValue, rowType: XLFormRowDescriptorTypeText, title: "Name")
        row.required = true
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewEmail.rawValue, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        // validate the email
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Twitter
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewTwitter.rawValue, rowType: XLFormRowDescriptorTypeTwitter, title: "Twitter")
        row.disabled = NSNumber(bool: true)
        row.value = "@no_editable"
        section.addFormRow(row)
    
        // Url
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewUrl.rawValue, rowType: XLFormRowDescriptorTypeURL, title: "Url")
        section.addFormRow(row)
        
    
        // Date
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewDate.rawValue, rowType:XLFormRowDescriptorTypeDateInline, title:"Date Inline")
        row.value = NSDate()
        section.addFormRow(row)

        
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        
        
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewTextView.rawValue, rowType:XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "TEXT VIEW EXAMPLE"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewCheck.rawValue, rowType:XLFormRowDescriptorTypeBooleanCheck, title:"Check")
        section.addFormRow(row)

        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewNotes.rawValue, rowType:XLFormRowDescriptorTypeTextView, title:"Notes")
        section.addFormRow(row)
    
        self.form = form
    }

    
    override func inputAccessoryViewForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> UIView! {
        if self.form.formRowWithTag(Tags.AccessoryViewRowNavigationShowAccessoryView.rawValue)!.value!.boolValue == false {
            return nil
        }
        return super.inputAccessoryViewForRowDescriptor(rowDescriptor)
    }
    
    
//MARK: XLFormDescriptorDelegate
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if formRow.tag == Tags.AccessoryViewRowNavigationStopDisableRow.rawValue {
            if formRow.value!.boolValue  == true {
                self.form.rowNavigationOptions = self.form.rowNavigationOptions.union(XLFormRowNavigationOptions.StopDisableRow)
            }
            else{
                self.form.rowNavigationOptions = self.form.rowNavigationOptions.subtract(XLFormRowNavigationOptions.StopDisableRow)
            }
        }
        else if formRow.tag == Tags.AccessoryViewRowNavigationStopInlineRow.rawValue {
            if formRow.value!.boolValue  == true {
                self.form.rowNavigationOptions = self.form.rowNavigationOptions.union(XLFormRowNavigationOptions.StopInlineRow)
            }
            else{
                var options = self.form.rowNavigationOptions
                options = options.subtract(XLFormRowNavigationOptions.StopInlineRow)
                self.form.rowNavigationOptions = options
            }
        }
        else if formRow.tag == Tags.AccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow.rawValue {
            if formRow.value!.boolValue  == true {
                self.form.rowNavigationOptions = self.form.rowNavigationOptions.union(XLFormRowNavigationOptions.SkipCanNotBecomeFirstResponderRow)
            }
            else{
                var options = self.form.rowNavigationOptions
                options = options.subtract(XLFormRowNavigationOptions.SkipCanNotBecomeFirstResponderRow)
                self.form.rowNavigationOptions = options
            }
        }
        
    }

}
