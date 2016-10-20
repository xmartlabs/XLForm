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


    fileprivate struct Tags {
        static let AccessoryViewRowNavigationEnabled = "RowNavigationEnabled"
        static let AccessoryViewRowNavigationShowAccessoryView     = "RowNavigationShowAccessoryView"
        static let AccessoryViewRowNavigationStopDisableRow        = "rowNavigationStopDisableRow"
        static let AccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow = "rowNavigationSkipCanNotBecomeFirstResponderRow"
        static let AccessoryViewRowNavigationStopInlineRow = "rowNavigationStopInlineRow"
        static let AccessoryViewName = "name"
        static let AccessoryViewEmail = "email"
        static let AccessoryViewTwitter = "twitter"
        static let AccessoryViewUrl = "url"
        static let AccessoryViewDate = "date"
        static let AccessoryViewTextView = "textView"
        static let AccessoryViewCheck = "check"
        static let AccessoryViewNotes = "notes"
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
        
        form = XLFormDescriptor(title: "Accessory View")
        form.rowNavigationOptions = .enabled
    
        // Configuration section
        section = XLFormSectionDescriptor()
        section.title = "Row Navigation Settings"
        section.footerTitle = "Changing the Settings values you will navigate differently"
        form.addFormSection(section)
    
        // RowNavigationEnabled
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationEnabled, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Row Navigation Enabled?")
        row.value = true
        section.addFormRow(row)
    
        // RowNavigationShowAccessoryView
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationShowAccessoryView, rowType:XLFormRowDescriptorTypeBooleanCheck, title:"Show input accessory row?")
        row.value = form.rowNavigationOptions.contains(.enabled)
        row.hidden = "$\(Tags.AccessoryViewRowNavigationEnabled) == 0"
        section.addFormRow(row)

        // RowNavigationStopDisableRow
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationStopDisableRow, rowType: XLFormRowDescriptorTypeBooleanCheck, title:"Stop when reach disabled row?")
        row.value = form.rowNavigationOptions.contains(.stopDisableRow)
        row.hidden = "$\(Tags.AccessoryViewRowNavigationEnabled) == 0"
        section.addFormRow(row)
    
        // RowNavigationStopInlineRow
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationStopInlineRow, rowType: XLFormRowDescriptorTypeBooleanCheck, title: "Stop when reach inline row?")
        row.value = form.rowNavigationOptions.contains(.stopInlineRow)
        row.hidden = "$\(Tags.AccessoryViewRowNavigationEnabled) == 0"
        section.addFormRow(row)
        
        // RowNavigationSkipCanNotBecomeFirstResponderRow
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow, rowType:XLFormRowDescriptorTypeBooleanCheck, title:"Skip Can Not Become First Responder Row?")
        row.value = form.rowNavigationOptions.contains(XLFormRowNavigationOptions.skipCanNotBecomeFirstResponderRow)
        row.hidden = "$\(Tags.AccessoryViewRowNavigationEnabled) == 0"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        // Name
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewName, rowType: XLFormRowDescriptorTypeText, title: "Name")
        row.isRequired = true
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewEmail, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        // validate the email
        row.addValidator(XLFormValidator.email())
        section.addFormRow(row)
        
        // Twitter
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewTwitter, rowType: XLFormRowDescriptorTypeTwitter, title: "Twitter")
        row.disabled = NSNumber(value: true as Bool)
        row.value = "@no_editable"
        section.addFormRow(row)
    
        // Url
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewUrl, rowType: XLFormRowDescriptorTypeURL, title: "Url")
        section.addFormRow(row)
        
    
        // Date
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewDate, rowType:XLFormRowDescriptorTypeDateInline, title:"Date Inline")
        row.value = Date()
        section.addFormRow(row)

        
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        
        
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewTextView, rowType:XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "TEXT VIEW EXAMPLE"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewCheck, rowType:XLFormRowDescriptorTypeBooleanCheck, title:"Check")
        section.addFormRow(row)

        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.AccessoryViewNotes, rowType:XLFormRowDescriptorTypeTextView, title:"Notes")
        section.addFormRow(row)
    
        self.form = form
    }

    
    override func inputAccessoryView(for rowDescriptor: XLFormRowDescriptor!) -> UIView! {
        if (form.formRow(withTag: Tags.AccessoryViewRowNavigationShowAccessoryView)!.value! as AnyObject).boolValue == false {
            return nil
        }
        return super.inputAccessoryView(for: rowDescriptor)
    }
    
    
//MARK: XLFormDescriptorDelegate
    
    override func formRowDescriptorValueHasChanged(_ formRow: XLFormRowDescriptor!, oldValue: Any!, newValue: Any!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if formRow.tag == Tags.AccessoryViewRowNavigationStopDisableRow {
            if (formRow.value! as AnyObject).boolValue  == true {
                form.rowNavigationOptions = form.rowNavigationOptions.union(.stopDisableRow)
            }
            else{
                form.rowNavigationOptions = form.rowNavigationOptions.subtracting(.stopDisableRow)
            }
        }
        else if formRow.tag == Tags.AccessoryViewRowNavigationStopInlineRow {
            if (formRow.value! as AnyObject).boolValue  == true {
                form.rowNavigationOptions = form.rowNavigationOptions.union(.stopInlineRow)
            }
            else{
                var options = form.rowNavigationOptions
                options = options.subtracting(XLFormRowNavigationOptions.stopInlineRow)
                form.rowNavigationOptions = options
            }
        }
        else if formRow.tag == Tags.AccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow {
            if (formRow.value! as AnyObject).boolValue  == true {
                form.rowNavigationOptions = form.rowNavigationOptions.union(.skipCanNotBecomeFirstResponderRow)
            }
            else{
                var options = form.rowNavigationOptions
                options = options.subtracting(.skipCanNotBecomeFirstResponderRow)
                form.rowNavigationOptions = options
            }
        }
        
    }

}
