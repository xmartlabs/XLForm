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

    private enum Tags : String {
        case DateInline = "dateInline"
        case TimeInline = "timeInline"
        case DateTimeInline = "dateTimeInline"
        case CountDownTimerInline = "countDownTimerInline"
        case DatePicker = "datePicker"
        case Date = "date"
        case Time = "time"
        case DateTime = "dateTime"
        case CountDownTimer = "countDownTimer"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton = UIBarButtonItem(title: "Disable", style: UIBarButtonItemStyle.Plain, target: self, action: "disableEnable:")
        barButton.possibleTitles = Set(["Disable", "Enable"])
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    
    func disableEnable(button : UIBarButtonItem)
    {
        self.form.disabled = !self.form.disabled
        button.title = self.form.disabled ? "Enable" : "Disable"
        self.tableView.endEditing(true)
        self.tableView.reloadData()
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Date & Time")
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Inline Dates")
        form.addFormSection(section)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.DateInline.rawValue, rowType: XLFormRowDescriptorTypeDateInline, title:"Date")
        row.value = NSDate()
        section.addFormRow(row)
        
        // Time
        row = XLFormRowDescriptor(tag: Tags.TimeInline.rawValue, rowType: XLFormRowDescriptorTypeTimeInline, title: "Time")
        row.value = NSDate()
        section.addFormRow(row)
        
        // DateTime
        row = XLFormRowDescriptor(tag: Tags.DateTimeInline.rawValue, rowType: XLFormRowDescriptorTypeDateTimeInline, title: "Date Time")
        row.value = NSDate()
        section.addFormRow(row)
        
        // CountDownTimer
        row = XLFormRowDescriptor(tag: Tags.CountDownTimerInline.rawValue, rowType:XLFormRowDescriptorTypeCountDownTimerInline, title:"Countdown Timer")
        row.value = NSDate()
        section.addFormRow(row)
        

        section = XLFormSectionDescriptor.formSectionWithTitle("Dates") //
        form.addFormSection(section)

        
        // Date
        row = XLFormRowDescriptor(tag: Tags.Date.rawValue, rowType:XLFormRowDescriptorTypeDate, title:"Date")
        row.value = NSDate()
        row.cellConfigAtConfigure["minimumDate"] = NSDate()
        row.cellConfigAtConfigure["maximumDate"] = NSDate(timeIntervalSinceNow: 60*60*24*3)
        section.addFormRow(row)
        
        // Time
        row = XLFormRowDescriptor(tag: Tags.Time.rawValue, rowType: XLFormRowDescriptorTypeTime, title: "Time")
        row.cellConfigAtConfigure["minuteInterval"] = 10
        row.value = NSDate()
        section.addFormRow(row)
        
        // DateTime
        row = XLFormRowDescriptor(tag: Tags.DateTime.rawValue, rowType: XLFormRowDescriptorTypeDateTime, title: "Date Time")
        row.value = NSDate()
        section.addFormRow(row)
        
        // CountDownTimer
        row = XLFormRowDescriptor(tag: Tags.CountDownTimer.rawValue, rowType: XLFormRowDescriptorTypeCountDownTimer, title: "Countdown Timer")
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
        row = XLFormRowDescriptor(tag: Tags.DatePicker.rawValue, rowType:XLFormRowDescriptorTypeDatePicker)
        row.cellConfigAtConfigure["datePicker.datePickerMode"] = UIDatePickerMode.Date.rawValue
        row.value = NSDate()
        section.addFormRow(row)
        
        
        self.form = form
    }
    
    
// MARK: - XLFormDescriptorDelegate
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if  formRow.tag ==  Tags.DatePicker.rawValue {
            let alertView = UIAlertView(title: "DatePicker", message: "Value Has changed!", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
    }

}
