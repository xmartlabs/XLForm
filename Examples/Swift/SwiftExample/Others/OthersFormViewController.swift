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

    fileprivate struct Tags {
        static let SwitchBool = "switchBool"
        static let SwitchCheck = "switchCheck"
        static let StepCounter = "stepCounter"
        static let Slider = "slider"
        static let SegmentedControl = "segmentedControl"
        static let Custom = "custom"
        static let Info = "info"
        static let Button = "button"
		static let Image = "image"
        static let ButtonLeftAligned = "buttonLeftAligned"
        static let ButtonWithSegueId = "buttonWithSegueId"
        static let ButtonWithSegueClass = "buttonWithSegueClass"
        static let ButtonWithNibName = "buttonWithNibName"
        static let ButtonWithStoryboardId = "buttonWithStoryboardId"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }


    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Other Cells")
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Other Cells")
        section.footerTitle = "OthersFormViewController.swift"
        form.addFormSection(section)
        
        // Switch
        section.addFormRow(XLFormRowDescriptor(tag: Tags.SwitchBool, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Switch"))
        
        // Check
        section.addFormRow(XLFormRowDescriptor(tag: Tags.SwitchCheck, rowType: XLFormRowDescriptorTypeBooleanCheck, title: "Check"))
        
        // Step counter
        section.addFormRow(XLFormRowDescriptor(tag: Tags.StepCounter, rowType: XLFormRowDescriptorTypeStepCounter, title: "Step counter"))
        
        // Segmented Control
        row = XLFormRowDescriptor(tag: Tags.SegmentedControl, rowType: XLFormRowDescriptorTypeSelectorSegmentedControl, title: "Fruits")
        row.selectorOptions = ["Apple", "Orange", "Pear"]
        row.value = "Pear"
        section.addFormRow(row)

        row = XLFormRowDescriptor(tag: Tags.SegmentedControl, rowType: XLFormRowDescriptorTypeSegmentedInline, title: "Fruits Inline")
        row.selectorOptions = ["Apple", "Orange", "Pear"]
        row.value = "Pear"
        section.addFormRow(row)

        
        
        // Slider
        row = XLFormRowDescriptor(tag: Tags.Slider, rowType: XLFormRowDescriptorTypeSlider, title: "Slider")
        row.value = 30
        row.cellConfigAtConfigure["slider.maximumValue"] = 100
        row.cellConfigAtConfigure["slider.minimumValue"] = 10
        row.cellConfigAtConfigure["steps"] = 4
        section.addFormRow(row)
		
		// Image
		row = XLFormRowDescriptor(tag: Tags.Image, rowType: XLFormRowDescriptorTypeImage, title: "Image")
		row.value = UIImage(named: "default_avatar")
		section.addFormRow(row)

        // Info cell
        row = XLFormRowDescriptor(tag: Tags.Info, rowType: XLFormRowDescriptorTypeInfo)
        row.title = "Version"
        row.value = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Buttons")
        section.footerTitle = "Blue buttons will show a message when Switch is ON"
        form.addFormSection(section)
    
        // Button
        row = XLFormRowDescriptor(tag: Tags.Button, rowType: XLFormRowDescriptorTypeButton, title: "Button")
        row.cellConfig["textLabel.textColor"] = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        row.action.formSelector = #selector(OthersFormViewController.didTouchButton(_:))
        section.addFormRow(row)
        
        
        // Left Button
        row = XLFormRowDescriptor(tag: Tags.ButtonLeftAligned, rowType: XLFormRowDescriptorTypeButton, title: "Button with Block")
        row.cellConfig["textLabel.textColor"] = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        row.cellConfig["textLabel.textAlignment"] = NSTextAlignment.left.rawValue
        row.cellConfig["accessoryType"] = UITableViewCellAccessoryType.disclosureIndicator.rawValue
        row.action.formBlock = { [weak self] (sender: XLFormRowDescriptor!) -> Void in
            let switchRow = sender.sectionDescriptor.formDescriptor!.formRow(withTag: Tags.SwitchBool)!
            if let value = switchRow.value , (value as AnyObject).boolValue == true {
                let alertView = UIAlertView(title: "Switch is ON", message: "Button has checked the switch value...", delegate: self, cancelButtonTitle: "OK")
                alertView.show()
            }
            self?.deselectFormRow(sender)
        }
        section.addFormRow(row)
        
    
        // Another Left Button with segue
        row = XLFormRowDescriptor(tag: Tags.ButtonWithSegueClass, rowType: XLFormRowDescriptorTypeButton, title: "Button with Segue Class")
        row.action.formSegueClass = NSClassFromString("UIStoryboardPushSegue")
        row.action.viewControllerClass = MapViewController.self
        row.value = CLLocation(latitude: -33.0, longitude: -56.0)
        section.addFormRow(row)
        
        
        // Button with SegueId
        row = XLFormRowDescriptor(tag: Tags.ButtonWithSegueId, rowType: XLFormRowDescriptorTypeButton, title: "Button with Segue Idenfifier")
        row.action.formSegueIdentifier = "MapViewControllerSegue"
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        
        // Another Button using StoryboardId
        row = XLFormRowDescriptor(tag: Tags.ButtonWithStoryboardId, rowType: XLFormRowDescriptorTypeButton, title: "Button with StoryboardId")
        row.action.viewControllerStoryboardId = "MapViewController"
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        // Button using NibName
        row = XLFormRowDescriptor(tag: Tags.ButtonWithNibName, rowType: XLFormRowDescriptorTypeButton, title: "Button with NibName")
        row.action.viewControllerNibName = "MapViewController"
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        self.form = form
    }
    
    func didTouchButton(_ sender: XLFormRowDescriptor) {
        if (sender.sectionDescriptor.formDescriptor.formRow(withTag: Tags.SwitchBool)?.value as AnyObject).boolValue == true{
            let alertView = UIAlertView(title: "Switch is ON", message: "Button has checked the switch value...", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
        self.deselectFormRow(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeForm()

        let barButton = UIBarButtonItem(title: "Disable", style: .plain, target: self, action: #selector(OthersFormViewController.disableEnable(_:)))
        barButton.possibleTitles = Set(["Disable", "Enable"])
        navigationItem.rightBarButtonItem = barButton
    }
    
    
    func disableEnable(_ button : UIBarButtonItem) {
        form.isDisabled = !form.isDisabled
        button.title = form.isDisabled ? "Enable" : "Disable"
        tableView.endEditing(true)
        tableView.reloadData()
    }

}
