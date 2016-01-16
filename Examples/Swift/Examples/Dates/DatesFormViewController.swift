//
//  DatesFormViewController.swift
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


class DatesFormViewController: XLFormViewController {

    private struct Tags {
        static let DateInline = "dateInline"
        static let TimeInline = "timeInline"
        static let DateTimeInline = "dateTimeInline"
        static let CountDownTimerInline = "countDownTimerInline"
        static let DatePicker = "datePicker"
        static let Date = "date"
        static let Time = "time"
        static let DateTime = "dateTime"
        static let CountDownTimer = "countDownTimer"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton = UIBarButtonItem(title: "Disable", style: .Plain, target: self, action: "disableEnable:")
        barButton.possibleTitles = Set(["Disable", "Enable"])
        navigationItem.rightBarButtonItem = barButton
    }
    
    
    func disableEnable(button : UIBarButtonItem){
        form.disabled = !form.disabled
        button.title = form.disabled ? "Enable" : "Disable"
        tableView.endEditing(true)
        tableView.reloadData()
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Date & Time")
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Inline Dates")
        form.addFormSection(section)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.DateInline, rowType: XLFormRowDescriptorTypeDateInline, title:"Date")
        row.value = NSDate()
        section.addFormRow(row)
        
        // Time
        row = XLFormRowDescriptor(tag: Tags.TimeInline, rowType: XLFormRowDescriptorTypeTimeInline, title: "Time")
        row.value = NSDate()
        section.addFormRow(row)
        
        // DateTime
        row = XLFormRowDescriptor(tag: Tags.DateTimeInline, rowType: XLFormRowDescriptorTypeDateTimeInline, title: "Date Time")
        row.value = NSDate()
        section.addFormRow(row)
        
        // CountDownTimer
        row = XLFormRowDescriptor(tag: Tags.CountDownTimerInline, rowType:XLFormRowDescriptorTypeCountDownTimerInline, title:"Countdown Timer")
        row.value = NSDate()
        section.addFormRow(row)
        

        section = XLFormSectionDescriptor.formSectionWithTitle("Dates") //
        form.addFormSection(section)

        
        // Date
        row = XLFormRowDescriptor(tag: Tags.Date, rowType:XLFormRowDescriptorTypeDate, title:"Date")
        row.value = NSDate()
        row.cellConfigAtConfigure["minimumDate"] = NSDate()
        row.cellConfigAtConfigure["maximumDate"] = NSDate(timeIntervalSinceNow: 60*60*24*3)
        section.addFormRow(row)
        
        // Time
        row = XLFormRowDescriptor(tag: Tags.Time, rowType: XLFormRowDescriptorTypeTime, title: "Time")
        row.cellConfigAtConfigure["minuteInterval"] = 10
        row.value = NSDate()
        section.addFormRow(row)
        
        // DateTime
        row = XLFormRowDescriptor(tag: Tags.DateTime, rowType: XLFormRowDescriptorTypeDateTime, title: "Date Time")
        row.value = NSDate()
        section.addFormRow(row)
        
        // CountDownTimer
        row = XLFormRowDescriptor(tag: Tags.CountDownTimer, rowType: XLFormRowDescriptorTypeCountDownTimer, title: "Countdown Timer")
        row.value = NSDate()
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Disabled Dates")
        section.footerTitle = "DatesFormViewController.swift"
        form.addFormSection(section)
        
        // Date
        row = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeDate, title: "Date")
        row.disabled = NSNumber(bool: true)
        row.required = true
        row.value = NSDate()
        section.addFormRow(row)

        

        section = XLFormSectionDescriptor.formSectionWithTitle("DatePicker")
        form.addFormSection(section)

        // DatePicker
        row = XLFormRowDescriptor(tag: Tags.DatePicker, rowType:XLFormRowDescriptorTypeDatePicker)
        row.cellConfigAtConfigure["datePicker.datePickerMode"] = UIDatePickerMode.Date.rawValue
        row.value = NSDate()
        section.addFormRow(row)
        
        
        self.form = form
    }
    
    
// MARK: - XLFormDescriptorDelegate
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if formRow.tag ==  Tags.DatePicker {
            let alertView = UIAlertView(title: "DatePicker", message: "Value Has changed!", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
    }

}
