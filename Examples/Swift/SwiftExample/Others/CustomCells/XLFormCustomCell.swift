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

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configure() {
        super.configure()
    }

    override func update() {
        super.update()
        // override
        self.textLabel!.text = self.rowDescriptor.value != nil ? self.rowDescriptor.value as? String : "Am a custom cell, select me!"
    }
   
    
    override func formDescriptorCellDidSelectedWithFormController(controller: XLFormViewController!) {
        // custom code here
        // i.e new behaviour when cell has been selected
        self.rowDescriptor.value = self.rowDescriptor.value as? String == "I can do any custom behaviour..." ? "Am a custom cell, select me!" : "I can do any custom behaviour..."
        self.update()
        controller.tableView .selectRowAtIndexPath(nil, animated: true, scrollPosition: UITableViewScrollPosition.None)
    }
    
}
