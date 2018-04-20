//
//  CustomSelectorsFormViewController.swift
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


class CustomSelectorsFormViewController : XLFormViewController {

    fileprivate struct Tags {
        static let SelectorMap = "selectorMap"
        static let SelectorMapPopover = "selectorMapPopover"
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Custom Selectors")
        
        section = XLFormSectionDescriptor.formSection(withTitle: "TextField Types")
        section.footerTitle = "CustomSelectorsFormViewController.swift"
        form.addFormSection(section)
    
        // Selector Push
        row = XLFormRowDescriptor(tag: Tags.SelectorMap, rowType: XLFormRowDescriptorTypeSelectorPush, title: "Coordinate")
        row.action.viewControllerClass = MapViewController.self
        row.valueTransformer = CLLocationValueTrasformer.self
        row.value = CLLocation(latitude: -33, longitude: -56)
        section.addFormRow(row)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Selector PopOver
            row = XLFormRowDescriptor(tag: Tags.SelectorMapPopover, rowType: XLFormRowDescriptorTypeSelectorPopover, title: "Coordinate PopOver")
            row.action.viewControllerClass = MapViewController.self
            row.valueTransformer = CLLocationValueTrasformer.self
            row.value = CLLocation(latitude: -33, longitude: -56)
            section.addFormRow(row)
        }
        self.form = form
    }
}
