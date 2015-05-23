//
//  ExamplesFormViewController.swift
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




class ExamplesFormViewController : XLFormViewController {

    private enum Tags : String {
        case RealExample = "RealExamples"
        case TextFieldAndTextView = "TextFieldAndTextView"
        case Selectors = "Selectors"
        case Othes = "Others"
        case Dates = "Dates"
        case Predicates = "BasicPredicates"
        case BlogExample = "BlogPredicates"
        case Multivalued = "Multivalued"
        case MultivaluedOnlyReorder = "MultivaluedOnlyReorder"
        case MultivaluedOnlyInsert = "MultivaluedOnlyInsert"
        case MultivaluedOnlyDelete = "MultivaluedOnlyDelete"
        case Validations = "Validations"
        case UICusomization = "Customization"
        case Custom = "Custom"
        case AccessoryView = "Accessory View"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    
// MARK: Helpers
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
                
        form = XLFormDescriptor()
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Real examples")
        form.addFormSection(section)
        
        // NativeEventFormViewController
        row = XLFormRowDescriptor(tag: Tags.RealExample.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "iOS Calendar Event Form")
        row.action.formSegueIdenfifier = "NativeEventNavigationViewControllerSegue"
        section.addFormRow(row)

        section = XLFormSectionDescriptor.formSectionWithTitle("This form is actually an example")
        section.footerTitle = "ExamplesFormViewController.swift, Select an option to view another example"
        form.addFormSection(section)
        

        // TextFieldAndTextView
        row = XLFormRowDescriptor(tag: Tags.TextFieldAndTextView.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Text Fields")
        row.action.viewControllerClass = InputsFormViewController.self
        section.addFormRow(row)
        
    
        // Selectors
        row = XLFormRowDescriptor(tag: Tags.Selectors.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Selectors")
        row.action.formSegueIdenfifier = "SelectorsFormViewControllerSegue"
        section.addFormRow(row)
        
    
        // Dates
        row = XLFormRowDescriptor(tag: Tags.Dates.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Date & Time")
        row.action.viewControllerClass = DatesFormViewController.self
        section.addFormRow(row)
        
        // Others
        row = XLFormRowDescriptor(tag: Tags.Othes.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Other Rows")
        row.action.formSegueIdenfifier = "OthersFormViewControllerSegue"
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Multivalued example")
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Multivalued.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Multivalued Sections")
        row.action.viewControllerClass = MultivaluedFormViewController.self
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.MultivaluedOnlyReorder.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Multivalued Only Reorder")
        row.action.viewControllerClass = MultivaluedOnlyReorderViewController.self
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.MultivaluedOnlyInsert.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Multivalued Only Insert")
        row.action.viewControllerClass = MultivaluedOnlyInserViewController.self
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.MultivaluedOnlyDelete.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Multivalued Only Delete")
        row.action.viewControllerClass = MultivaluedOnlyDeleteViewController.self
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSectionWithTitle("UI Customization")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.UICusomization.rawValue, rowType: XLFormRowDescriptorTypeButton, title:"UI Customization")
        row.action.viewControllerClass = UICustomizationFormViewController.self
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Custom Rows")
        form.addFormSection(section)

        
        row = XLFormRowDescriptor(tag: Tags.Custom.rawValue, rowType: XLFormRowDescriptorTypeButton, title:"Custom Rows")
        row.action.viewControllerClass = CustomRowsViewController.self
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Accessory View")
        form.addFormSection(section)

        row = XLFormRowDescriptor(tag: Tags.AccessoryView.rawValue, rowType: XLFormRowDescriptorTypeButton, title:"Accessory Views")
        row.action.viewControllerClass = AccessoryViewFormViewController.self
        section.addFormRow(row)
        
    
        section = XLFormSectionDescriptor.formSectionWithTitle("Validation Examples")
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Validations.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Validation Examples")
        row.action.formSegueIdenfifier = "ValidationExamplesFormViewControllerSegue"
        section.addFormRow(row)

        section = XLFormSectionDescriptor.formSectionWithTitle("Using Predicates")
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Predicates.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Very basic predicates")
        row.action.formSegueIdenfifier = "BasicPredicateViewControllerSegue"
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: Tags.Predicates.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Blog Example Hide predicates")
        row.action.formSegueIdenfifier = "BlogExampleViewSegue"
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: Tags.Predicates.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Another example")
        row.action.formSegueIdenfifier = "PredicateFormViewControllerSegue"
        section.addFormRow(row)
        
        self.form = form
    }
}
