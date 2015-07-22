//
//  BasicPredicateViewController.swift
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


class BasicPredicateViewController : XLFormViewController {

    private enum Tags : String {
        
        case HideRow = "tag1"
        case HideSection = "tag2"
        case Text = "tag3"

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
     
        form = XLFormDescriptor(title: "Basic Predicates")
        
        section = XLFormSectionDescriptor()
        section.title = "A Section"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.HideRow.rawValue, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Show next row")
        row.value = 0
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.HideSection.rawValue, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Show B Section")
        row.hidden = "$\(Tags.HideRow.rawValue)==0"
        row.value = 0
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "B Section"
        section.footerTitle = "BasicPredicateViewController.swift"
        section.hidden = "$\(Tags.HideSection.rawValue)==0"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Text.rawValue, rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Gonna disappear soon!!"
        section.addFormRow(row)
        
        self.form = form

        
    }
    
}
