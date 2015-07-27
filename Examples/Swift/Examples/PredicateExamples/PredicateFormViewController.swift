//
//  PredicateFormViewController.swift
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


class PredicateFormViewController : XLFormViewController {

    private enum Tags : String {
        case Text = "text"
        case Integer = "integer"
        case Switch = "switch"
        case Date = "date"
        case Account = "account"
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

        form = XLFormDescriptor(title: "Predicates example")
        
        section = XLFormSectionDescriptor()
        section.title = "Independent rows"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Text.rawValue, rowType: XLFormRowDescriptorTypeAccount, title:"Text")
        row.cellConfigAtConfigure["textField.placeholder"] = "Type disable"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Integer.rawValue, rowType: XLFormRowDescriptorTypeInteger, title:"Integer")
        row.hidden = NSPredicate(format: "$\(Tags.Switch.rawValue).value==0")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Switch.rawValue, rowType: XLFormRowDescriptorTypeBooleanSwitch, title:"Boolean")
        row.value = true
        section.addFormRow(row)
        
        form.addFormSection(section)
        
        section = XLFormSectionDescriptor()
        section.title = "Dependent section"
        section.footerTitle = "Type disable in the textfield, a number between 18 and 60 in the integer field or use the switch to disable the last row. By doing all three the last section will hide.\nThe integer field hides when the boolean switch is set to 0."
        form.addFormSection(section)
        
        // Predicate Disabling
        row = XLFormRowDescriptor(tag: Tags.Date.rawValue, rowType: XLFormRowDescriptorTypeDateInline, title:"Disabled")
        row.value = NSDate.new()
        section.addFormRow(row)
        row.disabled = NSPredicate(format: "$\(Tags.Text.rawValue).value contains[c] 'disable' OR ($\(Tags.Integer.rawValue).value between {18, 60}) OR ($\(Tags.Switch.rawValue).value == 0)")
        section.hidden = NSPredicate(format: "($\(Tags.Text.rawValue).value contains[c] 'disable') AND ($\(Tags.Integer.rawValue).value between {18, 60}) AND ($\(Tags.Switch.rawValue).value == 0)")
        
        
        
        section = XLFormSectionDescriptor()
        section.title = "More predicates..."
        section.footerTitle = "This row hides when the row of the previous section is disabled and the textfield in the first section contains \"out\"\n\nPredicateFormViewController.swift"
        form.addFormSection(section)
        
        
        
        row = XLFormRowDescriptor(tag: "thirds", rowType:XLFormRowDescriptorTypeAccount, title:"Account")
        section.addFormRow(row)
        row.hidden =  NSPredicate(format: "$\(Tags.Date.rawValue).isDisabled == 1 AND $\(Tags.Text.rawValue).value contains[c] 'Out'")
        
        
        row.onChangeBlock = {
            let noValue = "No Value"
            let message = "Old value: \($0 ?? noValue), New value: \($1 ?? noValue)"
            let alertView = UIAlertController(title: "Account Field changed", message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
            alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            let row = $2
            self.navigationController?.presentViewController(alertView, animated: true, completion: nil)
        }
        
        self.form = form
    }
    
}











