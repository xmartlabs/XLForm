//
//  InputsFormViewController.swift
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
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


class InputsFormViewController : XLFormViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }

    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        
        form = XLFormDescriptor.formDescriptorWithTitle("Text Fields") as! XLFormDescriptor;
        form.assignFirstResponderOnShow = true;
        
        section = XLFormSectionDescriptor.formSection () as! XLFormSectionDescriptor
        form.addFormSection(section);
        
        // Title
        row = XLFormRowDescriptor.formRowDescriptorWithTag("title", rowType: XLFormRowDescriptorTypeText) as! XLFormRowDescriptor
        row.cellConfigAtConfigure["textField.placeholder"] = "Title"
        row.required = true
        section.addFormRow(row)
        
        // Location
        row = XLFormRowDescriptor.formRowDescriptorWithTag("location", rowType: XLFormRowDescriptorTypeText) as! XLFormRowDescriptor
        row.cellConfigAtConfigure["textField.placeholder"] = "Location"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection() as! XLFormSectionDescriptor
        form.addFormSection(section)
        
        // All-day
        row = XLFormRowDescriptor.formRowDescriptorWithTag("all-day", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "All-day") as! XLFormRowDescriptor
        section.addFormRow(row)
        
        // Starts
        row = XLFormRowDescriptor.formRowDescriptorWithTag("starts", rowType: XLFormRowDescriptorTypeDateTimeInline, title: "Starts") as! XLFormRowDescriptor
        row.value = NSDate(timeIntervalSinceNow: 60*60*24)
        section.addFormRow(row)
        
        // Ends
        row = XLFormRowDescriptor.formRowDescriptorWithTag("ends", rowType: XLFormRowDescriptorTypeDateTimeInline, title: "Ends") as! XLFormRowDescriptor
        row.value = NSDate(timeIntervalSinceNow: 60*60*25)
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection() as! XLFormSectionDescriptor
        form.addFormSection(section)
        
        // Repeat
        row = XLFormRowDescriptor.formRowDescriptorWithTag("repeat", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Repeat") as! XLFormRowDescriptor
        row.value = XLFormOptionsObject(value: 0, displayText: "Never")
        row.selectorTitle = "Repeat"
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText: "Never"),
                               XLFormOptionsObject(value: 1, displayText: "Every Day"),
                               XLFormOptionsObject(value: 2, displayText: "Every Week"),
                               XLFormOptionsObject(value: 3, displayText: "Every 2 Weeks"),
                               XLFormOptionsObject(value: 4, displayText: "Every Month"),
                               XLFormOptionsObject(value: 5, displayText: "Every Year")]
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection() as! XLFormSectionDescriptor
        form.addFormSection(section)
        
        // Alert
        row = XLFormRowDescriptor.formRowDescriptorWithTag("alert", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Alert") as! XLFormRowDescriptor
        row.value = XLFormOptionsObject(value: 0, displayText: "None")
        row.selectorTitle = "Event Alert"
        row.selectorOptions = [
                               XLFormOptionsObject(value: 0, displayText: "None"),
                               XLFormOptionsObject(value: 1, displayText: "At time of event"),
                               XLFormOptionsObject(value: 2, displayText: "5 minutes before"),
                               XLFormOptionsObject(value: 3, displayText: "15 minutes before"),
                               XLFormOptionsObject(value: 4, displayText: "30 minutes before"),
                               XLFormOptionsObject(value: 5, displayText: "1 hour before"),
                               XLFormOptionsObject(value: 6, displayText: "2 hours before"),
                               XLFormOptionsObject(value: 7, displayText: "1 day before"),
                               XLFormOptionsObject(value: 8, displayText: "2 days before")]
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSection() as! XLFormSectionDescriptor
        form.addFormSection(section)
        
        // Show As
        row = XLFormRowDescriptor.formRowDescriptorWithTag("showAs", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Show As") as! XLFormRowDescriptor
        row.value = XLFormOptionsObject(value: 0, displayText: "Busy")
        row.selectorTitle = "Show As"
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText:"Busy"),
                               XLFormOptionsObject(value: 1, displayText:"Free")]
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection() as! XLFormSectionDescriptor
        form.addFormSection(section)
        
        // URL
        row = XLFormRowDescriptor.formRowDescriptorWithTag("url", rowType:XLFormRowDescriptorTypeURL) as! XLFormRowDescriptor
        row.cellConfigAtConfigure["textField.placeholder"] = "URL"
        section.addFormRow(row)
        
        // Notes
        row = XLFormRowDescriptor.formRowDescriptorWithTag("notes", rowType:XLFormRowDescriptorTypeTextView) as! XLFormRowDescriptor
        row.cellConfigAtConfigure["textView.placeholder"] = "Notes"
        section.addFormRow(row)
        
        self.form = form;
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
    }


    func savePressed(button: UIBarButtonItem){
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first);
            return;
        }
        self.tableView.endEditing(true)
    //    let alertView = UIAlertView(  alloc] initWithTitle:NSLocalizedString(@"Valid Form", nil) message:@"No errors found" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    //    [alertView show];
    }

}
