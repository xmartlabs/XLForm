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

    fileprivate struct Tags {
        static let RealExample = "RealExamples"
        static let TextFieldAndTextView = "TextFieldAndTextView"
        static let Selectors = "Selectors"
        static let Othes = "Others"
        static let Dates = "Dates"
        static let Predicates = "BasicPredicates"
        static let BlogExample = "BlogPredicates"
        static let Multivalued = "Multivalued"
        static let MultivaluedOnlyReorder = "MultivaluedOnlyReorder"
        static let MultivaluedOnlyInsert = "MultivaluedOnlyInsert"
        static let MultivaluedOnlyDelete = "MultivaluedOnlyDelete"
        static let Validations = "Validations"
        static let UICusomization = "Customization"
        static let Custom = "Custom"
        static let AccessoryView = "Accessory View"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    
// MARK: Helpers
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
                
        form = XLFormDescriptor()
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Real examples")
        form.addFormSection(section)
        
        // NativeEventFormViewController
        row = XLFormRowDescriptor(tag: Tags.RealExample, rowType: XLFormRowDescriptorTypeButton, title: "iOS Calendar Event Form")
        row.action.formSegueIdentifier = "NativeEventNavigationViewControllerSegue"
        section.addFormRow(row)

        section = XLFormSectionDescriptor.formSection(withTitle: "This form is actually an example")
        section.footerTitle = "ExamplesFormViewController.swift, Select an option to view another example"
        form.addFormSection(section)
        

        // TextFieldAndTextView
        row = XLFormRowDescriptor(tag: Tags.TextFieldAndTextView, rowType: XLFormRowDescriptorTypeButton, title: "Text Fields")
        row.action.viewControllerClass = InputsFormViewController.self
        section.addFormRow(row)
        
    
        // Selectors
        row = XLFormRowDescriptor(tag: Tags.Selectors, rowType: XLFormRowDescriptorTypeButton, title: "Selectors")
        row.action.formSegueIdentifier = "SelectorsFormViewControllerSegue"
        section.addFormRow(row)
        
    
        // Dates
        row = XLFormRowDescriptor(tag: Tags.Dates, rowType: XLFormRowDescriptorTypeButton, title: "Date & Time")
        row.action.viewControllerClass = DatesFormViewController.self
        section.addFormRow(row)
        
        // Others
        row = XLFormRowDescriptor(tag: Tags.Othes, rowType: XLFormRowDescriptorTypeButton, title: "Other Rows")
        row.action.formSegueIdentifier = "OthersFormViewControllerSegue"
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Multivalued example")
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Multivalued, rowType: XLFormRowDescriptorTypeButton, title: "Multivalued Sections")
        row.action.viewControllerClass = MultivaluedFormViewController.self
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.MultivaluedOnlyReorder, rowType: XLFormRowDescriptorTypeButton, title: "Multivalued Only Reorder")
        row.action.viewControllerClass = MultivaluedOnlyReorderViewController.self
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.MultivaluedOnlyInsert, rowType: XLFormRowDescriptorTypeButton, title: "Multivalued Only Insert")
        row.action.viewControllerClass = MultivaluedOnlyInserViewController.self
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.MultivaluedOnlyDelete, rowType: XLFormRowDescriptorTypeButton, title: "Multivalued Only Delete")
        row.action.viewControllerClass = MultivaluedOnlyDeleteViewController.self
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSection(withTitle: "UI Customization")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.UICusomization, rowType: XLFormRowDescriptorTypeButton, title:"UI Customization")
        row.action.viewControllerClass = UICustomizationFormViewController.self
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Custom Rows")
        form.addFormSection(section)

        
        row = XLFormRowDescriptor(tag: Tags.Custom, rowType: XLFormRowDescriptorTypeButton, title:"Custom Rows")
        row.action.viewControllerClass = CustomRowsViewController.self
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Accessory View")
        form.addFormSection(section)

        row = XLFormRowDescriptor(tag: Tags.AccessoryView, rowType: XLFormRowDescriptorTypeButton, title:"Accessory Views")
        row.action.viewControllerClass = AccessoryViewFormViewController.self
        section.addFormRow(row)
        
    
        section = XLFormSectionDescriptor.formSection(withTitle: "Validation Examples")
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Validations, rowType: XLFormRowDescriptorTypeButton, title: "Validation Examples")
        row.action.formSegueIdentifier = "ValidationExamplesFormViewControllerSegue"
        section.addFormRow(row)

        section = XLFormSectionDescriptor.formSection(withTitle: "Using Predicates")
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Predicates, rowType: XLFormRowDescriptorTypeButton, title: "Very basic predicates")
        row.action.formSegueIdentifier = "BasicPredicateViewControllerSegue"
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: Tags.Predicates, rowType: XLFormRowDescriptorTypeButton, title: "Blog Example Hide predicates")
        row.action.formSegueIdentifier = "BlogExampleViewSegue"
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: Tags.Predicates, rowType: XLFormRowDescriptorTypeButton, title: "Another example")
        row.action.formSegueIdentifier = "PredicateFormViewControllerSegue"
        section.addFormRow(row)
        
        self.form = form
    }
}
