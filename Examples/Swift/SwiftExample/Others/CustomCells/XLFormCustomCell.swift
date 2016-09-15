//
//  XLFormCustomCell.swift
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

let XLFormRowDescriptorTypeCustom = "XLFormRowDescriptorTypeCustom"

class XLFormCustomCell : XLFormBaseCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configure() {
        super.configure()
    }

    override func update() {
        super.update()
        // override
        if let string = rowDescriptor?.value as? String {
            textLabel?.text = string
        }
        else {
            textLabel?.text = "Am a custom cell, select me!"
        }
    }
   
    override func formDescriptorCellDidSelected(withForm controller: XLFormViewController!) {
        // custom code here
        // i.e new behaviour when cell has been selected
        if let string = rowDescriptor?.value as? String , string == "Am a custom cell, select me!" {
            self.rowDescriptor?.value = string
        }
        else {
            self.rowDescriptor?.value = "I can do any custom behaviour..."
        }
        
        update()
        controller.tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
}
