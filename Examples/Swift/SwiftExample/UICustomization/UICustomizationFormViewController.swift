//
//  UICustomizationFormViewController.swift
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

class UICustomizationFormViewController : XLFormViewController {
    
    fileprivate struct Tags {
        static let Name = "Name"
        static let Button = "Button"
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        
        form = XLFormDescriptor(title: "UI Customization")
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
    
        // Name
        row = XLFormRowDescriptor(tag: Tags.Name, rowType: XLFormRowDescriptorTypeText, title:"Name")
        // change the background color
        row.cellConfigAtConfigure["backgroundColor"] = UIColor.green
        // font
        row.cellConfig["textLabel.font"] = UIFont.systemFont(ofSize: 30)
        // background color
        row.cellConfig["textField.backgroundColor"] = UIColor.gray
        // font
        row.cellConfig["textField.font"] = UIFont.systemFont(ofSize: 25)
        // alignment
        row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        
        // Section
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        //Button
        row = XLFormRowDescriptor(tag: Tags.Button, rowType: XLFormRowDescriptorTypeButton, title:"Button")
        row.cellConfigAtConfigure["backgroundColor"] = UIColor.purple
        row.cellConfig["textLabel.color"] = UIColor.white
        row.cellConfig["textLabel.font"] = UIFont.systemFont(ofSize: 40)
        section.addFormRow(row)
    
        self.form = form
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // change cell height of a particular cell
        if form.formRow(atIndex: indexPath)?.tag == "Name" {
            return 60.0
        }
        else if form.formRow(atIndex: indexPath)?.tag == "Button" {
            return 100.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

