//
//  DatesFormViewController.swift
//  XLForm ( https://github.com/xmartlabs/XLForm )
// 
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
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


class DatesFormViewController: XLFormViewController {

    struct tag {
        static let dateTime = "dateTime"
        static let date = "date"
        static let time = "time"
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.initializeForm()
        
        let saveIcon = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveData")
        navigationItem.rightBarButtonItem = saveIcon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //Customize Section Header
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor()
        header.textLabel.textColor =  UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0)
        header.textLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)!
    }
    
    func initializeForm() {
        var form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor.formDescriptorWithTitle("Dates") as XLFormDescriptor
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Inline Dates") as XLFormSectionDescriptor
        form.addFormSection(section)
        
        // Date
        row = XLFormRowDescriptor(tag: tag.date, rowType: XLFormRowDescriptorTypeDateInline, title:"Date")
        row.value = NSDate()
        section.addFormRow(row)
        
        // Time
        row = XLFormRowDescriptor(tag: tag.time, rowType: XLFormRowDescriptorTypeTimeInline, title: "Time")
        row.value = NSDate()
        section.addFormRow(row)
        
        // DateTime
        row = XLFormRowDescriptor(tag: tag.dateTime, rowType: XLFormRowDescriptorTypeDateTimeInline, title: "Date Time")
        row.value = NSDate()
        section.addFormRow(row)
        self.form = form;
    }
    
    func saveData(){
        var results = [String:String]()
        if let date = form.formRowWithTag(tag.date).value as? NSDate {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            results[tag.date] = formatter.stringFromDate(date)
        }
        println(results)
    }
    
}
