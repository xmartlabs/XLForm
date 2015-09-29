//
//  OthersFormViewController.swift
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

class OthersFormViewController : XLFormViewController {

    private enum Tags : String {
        case SwitchBool = "switchBool"
        case SwitchCheck = "switchCheck"
        case StepCounter = "stepCounter"
        case Slider = "slider"
        case SegmentedControl = "segmentedControl"
        case Custom = "custom"
        case Info = "info"
        case Button = "button"
        case ButtonLeftAligned = "buttonLeftAligned"
        case ButtonWithSegueId = "buttonWithSegueId"
        case ButtonWithSegueClass = "buttonWithSegueClass"
        case ButtonWithNibName = "buttonWithNibName"
        case ButtonWithStoryboardId = "buttonWithStoryboardId"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }


    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Other Cells")
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Other Cells")
        section.footerTitle = "OthersFormViewController.swift"
        form.addFormSection(section)
        
        // Switch
        section.addFormRow(XLFormRowDescriptor(tag: Tags.SwitchBool.rawValue, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Switch"))
        
        // Check
        section.addFormRow(XLFormRowDescriptor(tag: Tags.SwitchCheck.rawValue, rowType: XLFormRowDescriptorTypeBooleanCheck, title: "Check"))
        
        // Step counter
        section.addFormRow(XLFormRowDescriptor(tag: Tags.StepCounter.rawValue, rowType: XLFormRowDescriptorTypeStepCounter, title: "Step counter"))
        
        // Segmented Control
        row = XLFormRowDescriptor(tag: Tags.SegmentedControl.rawValue, rowType: XLFormRowDescriptorTypeSelectorSegmentedControl, title: "Fruits")
        row.selectorOptions = ["Apple", "Orange", "Pear"]
        row.value = "Pear"
        section.addFormRow(row)
        
        
        // Slider
        row = XLFormRowDescriptor(tag: Tags.Slider.rawValue, rowType: XLFormRowDescriptorTypeSlider, title: "Slider")
        row.value = 30
        row.cellConfigAtConfigure["slider.maximumValue"] = 100
        row.cellConfigAtConfigure["slider.minimumValue"] = 10
        row.cellConfigAtConfigure["steps"] = 4
        section.addFormRow(row)
        

        // Info cell
        row = XLFormRowDescriptor(tag: Tags.Info.rawValue, rowType: XLFormRowDescriptorTypeInfo)
        row.title = "Version"
        row.value = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Buttons")
        section.footerTitle = "Blue buttons will show a message when Switch is ON"
        form.addFormSection(section)
    
        // Button
        row = XLFormRowDescriptor(tag: Tags.Button.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Button")
        row.cellConfig["textLabel.textColor"] = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        row.action.formSelector = "didTouchButton:"
        section.addFormRow(row)
        
        
        // Left Button
        row = XLFormRowDescriptor(tag: Tags.ButtonLeftAligned.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Button with Block")
        row.cellConfig["textLabel.textColor"] = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        row.cellConfig["textLabel.textAlignment"] = NSTextAlignment.Left.rawValue
        row.cellConfig["accessoryType"] = UITableViewCellAccessoryType.DisclosureIndicator.rawValue
        row.action.formBlock = { (sender: XLFormRowDescriptor!) -> Void in
            let switchRow = sender.sectionDescriptor.formDescriptor!.formRowWithTag(Tags.SwitchBool.rawValue)!
            if switchRow.value != nil && switchRow.value!.boolValue == true {
                let alertView = UIAlertView(title: "Switch is ON", message: "Button has checked the switch value...", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
            self.deselectFormRow(sender)
        }
        section.addFormRow(row)
        
    
        // Another Left Button with segue
        row = XLFormRowDescriptor(tag: Tags.ButtonWithSegueClass.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Button with Segue Class")
        row.action.formSegueClass = NSClassFromString("UIStoryboardPushSegue")
        row.action.viewControllerClass = MapViewController.self
        row.value = CLLocation(latitude: -33.0, longitude: -56.0)
        section.addFormRow(row)
        
        
        // Button with SegueId
        row = XLFormRowDescriptor(tag: Tags.ButtonWithSegueId.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Button with Segue Idenfifier")
        row.action.formSegueIdenfifier = "MapViewControllerSegue"
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        
        // Another Button using StoryboardId
        row = XLFormRowDescriptor(tag: Tags.ButtonWithStoryboardId.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Button with StoryboardId")
        row.action.viewControllerStoryboardId = "MapViewController"
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        // Button using NibName
        row = XLFormRowDescriptor(tag: Tags.ButtonWithNibName.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Button with NibName")
        row.action.viewControllerNibName = "MapViewController"
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        self.form = form
    }
    
    
    func didTouchButton(sender: XLFormRowDescriptor) {
        if sender.sectionDescriptor.formDescriptor.formRowWithTag(Tags.SwitchBool.rawValue)?.value?.boolValue == true{
            let alertView = UIAlertView(title: "Switch is ON", message: "Button has checked the switch value...", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
        self.deselectFormRow(sender)
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

}
