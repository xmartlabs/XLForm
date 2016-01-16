//
//  SelectorsFormViewController.swift
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

import MapKit

// Mark -  NSValueTransformer

class NSArrayValueTrasformer : NSValueTransformer {

    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let arrayValue = value as? Array<AnyObject> {
            return String(format: "%d Item%@", arrayValue.count, arrayValue.count > 1 ? "s" : "")
        }
        else if let stringValue = value as? String {
            return String(format: "%@ - ) - Transformed", stringValue)
        }
        return nil
    }
}

class ISOLanguageCodesValueTranformer : NSValueTransformer {
 
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let stringValue = value as? String {
            return NSLocale.currentLocale().displayNameForKey(NSLocaleLanguageCode, value: stringValue)
        }
        return nil
    }
}

// Mark - SelectorsFormViewController

class SelectorsFormViewController : XLFormViewController {
    
    private struct Tags {
        static let Push = "selectorPush"
        static let Popover = "selectorPopover"
        static let ActionSheet = "selectorActionSheet"
        static let AlertView = "selectorAlertView"
        static let PickerView = "selectorPickerView"
        static let Picker = "selectorPicker"
        static let PickerViewInline = "selectorPickerViewInline"
        static let MultipleSelector = "multipleSelector"
        static let MultipleSelectorPopover = "multipleSelectorPopover"
        static let DynamicSelectors = "dynamicSelectors"
        static let CustomSelectors = "customSelectors"
        static let SelectorWithSegueId = "selectorWithSegueId"
        static let SelectorWithSegueClass = "selectorWithSegueClass"
        static let SelectorWithNibName = "selectorWithNibName"
        static let SelectorWithStoryboardId = "selectorWithStoryboardId"
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
    
    func disableEnable(button : UIBarButtonItem)
    {
        form.disabled = !form.disabled
        button.title = form.disabled ? "Enable" : "Disable"
        tableView.endEditing(true)
        tableView.reloadData()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Selectors")
        section = XLFormSectionDescriptor.formSectionWithTitle("Selectors")
        section.footerTitle = "SelectorsFormViewController.swift"
        form.addFormSection(section)
        
        
        // Selector Push
        row = XLFormRowDescriptor(tag: Tags.Push, rowType:XLFormRowDescriptorTypeSelectorPush, title:"Push")
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText: "Option 1"),
                                    XLFormOptionsObject(value: 1, displayText:"Option 2"),
                                    XLFormOptionsObject(value: 2, displayText:"Option 3"),
                                    XLFormOptionsObject(value: 3, displayText:"Option 4"),
                                    XLFormOptionsObject(value: 4, displayText:"Option 5")
                                    ]
        row.value = XLFormOptionsObject(value: 1, displayText:"Option 2")
        section.addFormRow(row)

        
        // Selector Popover
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            row = XLFormRowDescriptor(tag: Tags.Popover, rowType:XLFormRowDescriptorTypeSelectorPopover, title:"PopOver")
            row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]
            row.value = "Option 2"
            section.addFormRow(row)
        }
    
        // Selector Action Sheet
        row = XLFormRowDescriptor(tag :Tags.ActionSheet, rowType:XLFormRowDescriptorTypeSelectorActionSheet, title:"Sheet")
        row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
        row.value = "Option 3"
        section.addFormRow(row)
        
        
        
        // Selector Alert View
        row = XLFormRowDescriptor(tag: Tags.AlertView, rowType:XLFormRowDescriptorTypeSelectorAlertView, title:"Alert View")
        row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
        row.value = "Option 3"
        section.addFormRow(row)
        
        // Selector Picker View
        row = XLFormRowDescriptor(tag: Tags.PickerView, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"Picker View")
        row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
        row.value = "Option 4"
        section.addFormRow(row)
        
        
        // --------- Fixed Controls
        section = XLFormSectionDescriptor.formSectionWithTitle("Fixed Controls")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Picker, rowType:XLFormRowDescriptorTypePicker)
        row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
        row.value = "Option 1"
        section.addFormRow(row)
        
        // --------- Inline Selectors
        section = XLFormSectionDescriptor.formSectionWithTitle("Inline Selectors")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.MultipleSelector, rowType:XLFormRowDescriptorTypeSelectorPickerViewInline, title:"Inline Picker View")
        row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]
        row.value = "Option 6"
        section.addFormRow(row)
        
        // --------- MultipleSelector
        section = XLFormSectionDescriptor.formSectionWithTitle("Multiple Selectors")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.MultipleSelector, rowType:XLFormRowDescriptorTypeMultipleSelector, title:"Multiple Selector")
        row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]
        row.value = ["Option 1", "Option 3", "Option 4", "Option 5", "Option 6"]
        section.addFormRow(row)
        
        
        // Multiple selector with value tranformer
        row = XLFormRowDescriptor(tag: Tags.MultipleSelector, rowType:XLFormRowDescriptorTypeMultipleSelector, title:"Multiple Selector")
        row.selectorOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]
        row.value = ["Option 1", "Option 3", "Option 4", "Option 5", "Option 6"]
        row.valueTransformer = NSArrayValueTrasformer.self
        section.addFormRow(row)
        
        
        // Language multiple selector
        row = XLFormRowDescriptor(tag: Tags.MultipleSelector, rowType:XLFormRowDescriptorTypeMultipleSelector, title:"Multiple Selector")
        row.selectorOptions = NSLocale.ISOLanguageCodes()
        row.selectorTitle = "Languages"
        row.valueTransformer = ISOLanguageCodesValueTranformer.self
        row.value = NSLocale.preferredLanguages()
        section.addFormRow(row)

    
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // Language multiple selector popover
            row = XLFormRowDescriptor(tag: Tags.MultipleSelectorPopover, rowType:XLFormRowDescriptorTypeMultipleSelectorPopover, title:"Multiple Selector PopOver")
            row.selectorOptions = NSLocale.ISOLanguageCodes()
            row.valueTransformer = ISOLanguageCodesValueTranformer.self
            row.value = NSLocale.preferredLanguages()
            section.addFormRow(row)
        }
        
    
    
        // --------- Dynamic Selectors
        section = XLFormSectionDescriptor.formSectionWithTitle("Dynamic Selectors")
        form.addFormSection(section)

        row = XLFormRowDescriptor(tag: Tags.DynamicSelectors, rowType:XLFormRowDescriptorTypeButton, title:"Dynamic Selectors")
        row.action.viewControllerClass = DynamicSelectorsFormViewController.self
        section.addFormRow(row)
        
        
    
        // --------- Custom Selectors
        section = XLFormSectionDescriptor.formSectionWithTitle("Custom Selectors")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.CustomSelectors, rowType:XLFormRowDescriptorTypeButton, title:"Custom Selectors")
        row.action.viewControllerClass = CustomSelectorsFormViewController.self
        section.addFormRow(row)
        

        // --------- Selector definition types
        section = XLFormSectionDescriptor.formSectionWithTitle("Selectors")
        form.addFormSection(section)
        
        // selector with segue class
        row = XLFormRowDescriptor(tag: Tags.SelectorWithSegueClass, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Selector with Segue Class")
        row.action.formSegueClass = NSClassFromString("UIStoryboardPushSegue")
        row.action.viewControllerClass = MapViewController.self
        row.valueTransformer = CLLocationValueTrasformer.self
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        // selector with SegueId
        row = XLFormRowDescriptor(tag: Tags.SelectorWithSegueId, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Selector with Segue Idenfifier")
        row.action.formSegueIdentifier = "MapViewControllerSegue";
        row.valueTransformer = CLLocationValueTrasformer.self
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        // selector using StoryboardId
        row = XLFormRowDescriptor(tag: Tags.SelectorWithStoryboardId, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Selector with StoryboardId")
        row.action.viewControllerStoryboardId = "MapViewController";
        row.valueTransformer = CLLocationValueTrasformer.self
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        // selector with NibName
        row = XLFormRowDescriptor(tag: Tags.SelectorWithNibName, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Selector with NibName")
        row.action.viewControllerNibName = "MapViewController"
        row.valueTransformer = CLLocationValueTrasformer.self
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        self.form = form
    }
    
    
    override func storyboardForRow(formRow: XLFormRowDescriptor!) -> UIStoryboard! {
        return UIStoryboard(name: "iPhoneStoryboard", bundle:nil)
    }

}
