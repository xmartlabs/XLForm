//
//  UICustomizationFormViewController.swift
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014-2015 Xmartlabs ( http://xmartlabs.com )
//  Swift Example Contributed by Eric Gu
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
    
    //MARK: Tags
    
    private enum Tags : String {
        case FullName = "FULLNAME"
        case DateOfBirth = "DATEOFBIRTH"
        case Email = "EMAIL"
        case Button = "JOINTEAM"
    }
    
    //MARK: Customization Constants
    
    private let kPrimaryColor = UIColor.whiteColor()
    private let kSecondaryColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0)
    private let kStandardFontSize:CGFloat = 17
    private let kStandardFontName = "AppleSDGothicNeo-Regular"
    private let kBackgroundColor = UIColor.blackColor()
    private let kHeaderHeight: CGFloat = 40
    
    //MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    //MARK: View Setup
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        view.backgroundColor = kBackgroundColor
        tableView.separatorInset.right = tableView.separatorInset.left
        tableView.backgroundColor = kBackgroundColor
        tableView.rowHeight = super.tableView.rowHeight
        tableView.tableFooterView = UIView(frame: CGRectZero)
        navigationController?.navigationBar.backgroundColor = kBackgroundColor
        navigationController?.navigationBar.barTintColor = kBackgroundColor
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: kStandardFontName, size: 20)!, NSForegroundColorAttributeName: kPrimaryColor]
        navigationController?.navigationBar.tintColor = kPrimaryColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: kStandardFontName, size: 15)!], forState: UIControlState.Normal)
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }
    
    override func viewWillDisappear(animated: Bool) {
        //Optional Function - Resets Shared Nav Customization Before Returning to Examples Main Table View
        super.viewWillDisappear(false)
        navigationController?.navigationBar.backgroundColor = UIColor.grayColor()
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.blackColor()]
        navigationController?.navigationBar.tintColor = view.tintColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17)], forState: UIControlState.Normal)
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
    }
    
    //MARK: Form
    
    func initializeForm() {
        
        let customForm : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        customForm = XLFormDescriptor(title: "UI Customization")
    
        section = XLFormSectionDescriptor.formSectionWithTitle("Basics") as XLFormSectionDescriptor
        customForm.addFormSection(section)
        
        //FULLNAME
        row = XLFormRowDescriptor(tag: Tags.FullName.rawValue, rowType: XLFormRowDescriptorTypeText, title: "Full Name")
        
        row.cellConfig["backgroundColor"] = kBackgroundColor
        row.cellConfig["textLabel.textColor"] = kPrimaryColor
        row.cellConfig["self.tintColor"] = kPrimaryColor
        row.cellConfig["textLabel.font"] = UIFont(name: kStandardFontName, size: kStandardFontSize)!
        
        row.cellConfig["textField.textColor"] = kPrimaryColor
        row.cellConfig["textField.font"] = UIFont(name: kStandardFontName, size: kStandardFontSize)!
        row.cellConfigAtConfigure["textField.placeholder"] = "Required..."
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Right.rawValue
        row.value = "John Doe"
        section.addFormRow(row)

        // Date Of Birth
        row = XLFormRowDescriptor(tag: Tags.DateOfBirth.rawValue, rowType: XLFormRowDescriptorTypeDateInline, title:"Date Of Birth")
        row.value = NSDate()
        row.cellConfig["maximumDate"] = NSDate()
        row.cellConfig["backgroundColor"] = kBackgroundColor
        row.cellConfig["textLabel.textColor"] = kPrimaryColor
        row.cellConfig["self.tintColor"] = kPrimaryColor
        
        row.cellConfig["textLabel.font"] = UIFont(name: kStandardFontName, size: kStandardFontSize)!
        row.cellConfig["detailTextLabel.font"] = UIFont(name: kStandardFontName, size: kStandardFontSize)!
        row.cellConfig["detailTextLabel.textColor"] = kPrimaryColor
        
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.Email.rawValue, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        row.value = "user@email.com"
        //row.addValidator(XLFormValidator.emailValidator())
        //row.required = true
        
        row.cellConfig["backgroundColor"] = kBackgroundColor
        row.cellConfig["textLabel.textColor"] = kPrimaryColor
        row.cellConfig["textLabel.font"] = UIFont(name: kStandardFontName, size: kStandardFontSize)!
        row.cellConfig["self.tintColor"] = kPrimaryColor
        
        
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Right.rawValue
        row.cellConfig["textField.textColor"] = kPrimaryColor
        row.cellConfig["textField.font"] = UIFont(name: kStandardFontName, size: kStandardFontSize)!
        section.addFormRow(row)
        
        // Section
        section = XLFormSectionDescriptor.formSectionWithTitle("Join Team") as XLFormSectionDescriptor
        customForm.addFormSection(section)
        
        //Button
        row = XLFormRowDescriptor(tag: Tags.Button.rawValue, rowType: XLFormRowDescriptorTypeButton, title:"Join Team")
        row.cellConfigAtConfigure["backgroundColor"] = UIColor.purpleColor()
        row.cellConfig["textLabel.color"] = kPrimaryColor
        row.cellConfig["textLabel.font"] = UIFont(name: kStandardFontName, size: 25)!
        section.addFormRow(row)
    
        form = customForm
    }

    //MARK: TableView
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = kSecondaryColor
        header.textLabel.textColor =  kPrimaryColor
        header.textLabel.font = UIFont(name: kStandardFontName, size: 18)!
        header.frame.size.height = tableView.rowHeight
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.form.formRowAtIndex(indexPath)?.tag == Tags.Button.rawValue {
            return 60.0
        }
        else {
            return super.tableView.rowHeight
        }
    }
    
    
}

