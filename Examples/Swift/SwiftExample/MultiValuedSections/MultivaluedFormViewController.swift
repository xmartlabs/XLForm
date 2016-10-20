//
//  MultiValuedFormViewController.swift
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


class MultivaluedFormViewController : XLFormViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }

    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Multivalued Examples")
        
        // Multivalued section
        section = XLFormSectionDescriptor.formSection(withTitle: "Multivalued TextField", sectionOptions:XLFormSectionOptions.canReorder.union(.canInsert).union(.canDelete), sectionInsertMode:.button)
        section.multivaluedAddButton!.title = "Add New Tag"
        section.footerTitle = "XLFormSectionInsertModeButton sectionType adds a 'Add Item' (Add New Tag) button row as last cell."
        // set up the row template
        row = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeName)
        row.cellConfigAtConfigure["textField.placeholder"] = "Tag Name"
        section.multivaluedRowTemplate = row
        
        form.addFormSection(section)
        
        // Another Multivalued section
        section = XLFormSectionDescriptor.formSection(withTitle: "Multivalued ActionSheet Selector example", sectionOptions:XLFormSectionOptions.canInsert.union(.canDelete))
        section.footerTitle = "XLFormSectionInsertModeLastRow sectionType adds a '+' icon inside last table view cell allowing us to add a new row."
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Tap to select..")
        row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
        section.addFormRow(row)
    
    
        // Another one
        section = XLFormSectionDescriptor.formSection(withTitle: "Multivalued Push Selector example", sectionOptions: XLFormSectionOptions.canInsert.union(.canDelete).union(.canReorder), sectionInsertMode: .button)
        section.footerTitle = "MultivaluedFormViewController.swift"
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Tap to select )..")
        row.selectorOptions = ["Option 1", "Option 2", "Option 3"]
        section.multivaluedRowTemplate = row.copy() as? XLFormRowDescriptor
        section.addFormRow(row)
        
        self.form = form
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(MultivaluedFormViewController.addDidTouch(_:)))
    }
    
//MARK: - Actions
    
    func addDidTouch(_ sender: UIBarButtonItem) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Remove Last Section", otherButtonTitles: "Add a section at the end", self.form!.isDisabled ? "Enable Form" : "Disable Form")
        actionSheet.show(in: view)
    }

//MARK: - UIActionSheetDelegate


    override func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if actionSheet.destructiveButtonIndex == buttonIndex {
            if form.formSections.count > 0 {
                // remove last section
                form.removeFormSection(at: UInt(form.formSections.count - 1))
            }
        }
        else if actionSheet.buttonTitle(at: buttonIndex) == "Add a section at the end" {
            // add a new section
//            let dateString = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            let newSection  = XLFormSectionDescriptor.formSection(withTitle: "Section created at \(DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short))", sectionOptions:XLFormSectionOptions.canInsert.union(.canDelete))
            newSection.multivaluedTag = "multivaluedPushSelector_\(self.form.formSections.count)"
            let newRow = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Tap to select )..")
            newRow.selectorOptions = ["Option 1", "Option 2", "Option 3"]
            newSection.addFormRow(newRow)
            form.addFormSection(newSection)
        }
        else {
            form.isDisabled = !self.form.isDisabled
            tableView.endEditing(true)
            tableView.reloadData()
        }
    }
}




class MultivaluedOnlyReorderViewController : XLFormViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    func initializeForm() {
        
        let secondsPerDay = 24 * 60 * 60
        let list = ["Today", "Yesterday", "Before Yesterday"]
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Only Reorder Examples")
        
        // Multivalued Section with inline rows - section set up to support only reordering
        section = XLFormSectionDescriptor.formSection(withTitle: "Reordering Inline Rows",
                                                 sectionOptions:.canReorder)
        section.footerTitle = "XLFormRowDescriptorTypeDateInline row type"
        form.addFormSection(section)
        var idx = 0
        for listItem in list {
            idx += 1
            let timeIntervalSinceNow = TimeInterval(secondsPerDay * idx)
            row = XLFormRowDescriptor(tag: nil, rowType:XLFormRowDescriptorTypeDateInline, title: listItem)
            row.value = Date(timeIntervalSinceNow:timeIntervalSinceNow)
            section.addFormRow(row)
        }
    
        // Multivalued Section with common rows - section set up to support only reordering
        section = XLFormSectionDescriptor.formSection(withTitle: "Reordering Rows", sectionOptions:.canReorder)
        section.footerTitle = "XLFormRowDescriptorTypeInfo row type"
        form.addFormSection(section)
    
        
        idx = 0
        for listItem in list {
            idx += 1
            let timeIntervalSinceNow  = TimeInterval(secondsPerDay * idx)
            row = XLFormRowDescriptor(tag: nil, rowType:XLFormRowDescriptorTypeInfo, title: listItem)
            row.value = DateFormatter.localizedString(from: Date(timeIntervalSinceNow:timeIntervalSinceNow), dateStyle: .medium, timeStyle: .none)
            section.addFormRow(row)
        }
        
        self.form = form
    }
 
}

class MultivaluedOnlyInserViewController : XLFormViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    func initializeForm() {
        
        let nameList = ["family", "male", "female", "client"]
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Multivalued Only Insert")
    
        section = XLFormSectionDescriptor.formSection(withTitle: "XLFormSectionInsertModeButton", sectionOptions:.canInsert, sectionInsertMode:.button)
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: nil, rowType:XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Add a new tag"
        section.multivaluedRowTemplate = row
        
        section = XLFormSectionDescriptor.formSection(withTitle: "XLFormSectionInsertModeButton With Inline Cells", sectionOptions:.canInsert, sectionInsertMode:.button)
        row = XLFormRowDescriptor(tag: nil, rowType:XLFormRowDescriptorTypeDateInline)
        row.value = Date()
        row.title = "Date"
        section.multivaluedRowTemplate = row
        form.addFormSection(section)

        section = XLFormSectionDescriptor.formSection(withTitle: "XLFormSectionInsertModeLastRow",
                                                 sectionOptions:.canInsert, sectionInsertMode:.lastRow)
        form.addFormSection(section)
        for tag in nameList {
            // add a row to the section, the row will be used to crete new rows.
            row = XLFormRowDescriptor(tag: nil, rowType:XLFormRowDescriptorTypeText)
            row.cellConfig["textField.placeholder"] = "Add a new tag"
            row.value = tag
            section.addFormRow(row)
        }
        self.form = form
    }
}

class MultivaluedOnlyDeleteViewController : XLFormViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editing", style: .plain, target: self, action: #selector(MultivaluedOnlyDeleteViewController.toggleEditing(_:)))
    }
    
    func toggleEditing(_ sender : UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Editing" : "Not Editing"
    }
    
    func initializeForm() {
        
        let nameList = ["family", "male", "female", "client"]
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Multivalued Only Delete")
        
        section = XLFormSectionDescriptor.formSection(withTitle: "", sectionOptions:.canDelete)
        section.footerTitle = "you can swipe to delete when table.editing = NO (Not Editing)"
        form.addFormSection(section)
      
        
        for tag in nameList {
            row = XLFormRowDescriptor(tag: nil, rowType:XLFormRowDescriptorTypeText)
            row.cellConfig["textField.placeholder"] = "Add a new tag"
            row.value = tag
            section.addFormRow(row)
        }
    
        // Multivalued Section with inline row.
        section = XLFormSectionDescriptor.formSection(withTitle: "", sectionOptions:.canDelete)
        section.footerTitle = "you can swipe to delete when table.editing = NO (Not Editing)"
        form.addFormSection(section)
        
        for _ in 1...4 {
            row = XLFormRowDescriptor(tag: nil, rowType:XLFormRowDescriptorTypeSelectorPickerViewInline)
            row.title = "Tap to select"
            row.value = "client"
            row.selectorOptions = nameList
            section.addFormRow(row)
        }
        
        self.form = form
    }
    
    
}

