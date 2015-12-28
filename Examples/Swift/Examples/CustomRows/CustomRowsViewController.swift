//  CustomRowsViewController.swift
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

class CustomRowsViewController : XLFormViewController {
    
    private struct Tags {
        static let CustomRowFirstRatingTag = "CustomRowFirstRatingTag"
        static let CustomRowSecondRatingTag = "CustomRowSecondRatingTag"
        static let CustomRowFloatLabeledTextFieldTag = "CustomRowFloatLabeledTextFieldTag"
        static let CustomRowWeekdays = "CustomRowWeekdays"
        static let CustomRowText = "CustomText"
        static let CustomRowInline = "CustomRowInline"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
        
        form = XLFormDescriptor(title: "Custom Rows")
        
        section = XLFormSectionDescriptor()
        section.title = "Ratings"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.CustomRowFirstRatingTag, rowType: XLFormRowDescriptorTypeRate, title: "First Rating")
        row.value = 3
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.CustomRowSecondRatingTag, rowType: XLFormRowDescriptorTypeRate, title: "First Rating")
        row.value = 1
        section.addFormRow(row)
        
        // Section Float Labeled Text Field
        section = XLFormSectionDescriptor.formSectionWithTitle("Float Labeled Text Field")
        form.addFormSection(section)

        row = XLFormRowDescriptor(tag: Tags.CustomRowFloatLabeledTextFieldTag, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title: "Title")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.CustomRowFloatLabeledTextFieldTag, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title: "First Name")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.CustomRowFloatLabeledTextFieldTag, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title: "Last Name")
        section.addFormRow(row)
        

        section = XLFormSectionDescriptor.formSectionWithTitle("Weekdays")
        form.addFormSection(section)

        // WeekDays
        row = XLFormRowDescriptor(tag: Tags.CustomRowWeekdays, rowType: XLFormRowDescriptorTypeWeekDays)
        row.value =  [
            XLFormWeekDaysCell.kWeekDay.Sunday.description(): false,
            XLFormWeekDaysCell.kWeekDay.Monday.description(): true,
            XLFormWeekDaysCell.kWeekDay.Tuesday.description(): true,
            XLFormWeekDaysCell.kWeekDay.Wednesday.description(): false,
            XLFormWeekDaysCell.kWeekDay.Thursday.description(): false,
            XLFormWeekDaysCell.kWeekDay.Friday.description(): false,
            XLFormWeekDaysCell.kWeekDay.Saturday.description(): false
        ]
        section.addFormRow(row)

        section = XLFormSectionDescriptor.formSectionWithTitle("Custom inline row")
        form.addFormSection(section)
        
        // Inline
        row = XLFormRowDescriptor(tag: Tags.CustomRowInline, rowType: XLFormRowDescriptorTypeSegmentedInline)
        row.title = "You support..."
        row.selectorOptions = ["Uruguay", "Brazil", "Argentina", "Chile"]
        row.value = "Uruguay"
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.CustomRowText, rowType: XLFormRowDescriptorTypeCustom)
        // Must set custom cell or add custom cell to cellClassesForRowDescriptorTypes dictionary before XLFormViewController loaded
        row.cellClass = XLFormCustomCell.self
        section.addFormRow(row)
        
        self.form = form
    }
    
}

