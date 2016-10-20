//
//  InlineSegmentedCell.swift
//  SwiftExample
//
//  Created by mathias Claassen on 16/12/15.
//  Copyright © 2015 Xmartlabs. All rights reserved.
//

import Foundation

let XLFormRowDescriptorTypeSegmentedInline = "XLFormRowDescriptorTypeSegmentedInline"
let XLFormRowDescriptorTypeSegmentedControl = "XLFormRowDescriptorTypeSegmentedControl"


class InlineSegmentedCell : XLFormBaseCell {
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        if isFirstResponder {
            return super.becomeFirstResponder()
        }
        let result = super.becomeFirstResponder()
        if result {
            let inlineRowDescriptor : XLFormRowDescriptor = XLFormRowDescriptor(tag: nil, rowType: XLFormViewController.inlineRowDescriptorTypesForRowDescriptorTypes()![rowDescriptor!.rowType] as! String)
            let cell = inlineRowDescriptor.cell(forForm: formViewController())
            let inlineCell = cell as? XLFormInlineRowDescriptorCell
            inlineCell?.inlineRowDescriptor = rowDescriptor
            rowDescriptor?.sectionDescriptor.addFormRow(inlineRowDescriptor, afterRow: rowDescriptor!)
            formViewController().ensureRowIsVisible(inlineRowDescriptor)
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        if !isFirstResponder {
            return super.resignFirstResponder()
        }
        let selectedRowPath : IndexPath = formViewController().form.indexPath(ofFormRow: rowDescriptor!)!
        let nextRowPath = IndexPath(row: (selectedRowPath as NSIndexPath).row + 1, section: (selectedRowPath as NSIndexPath).section)
        let nextFormRow = formViewController().form.formRow(atIndex: nextRowPath)
        let section : XLFormSectionDescriptor = formViewController().form.formSection(at: UInt((nextRowPath as NSIndexPath).section))!
        let result = super.resignFirstResponder()
        if result {
            section.removeFormRow(nextFormRow!)
        }
        return result
    }
    
    //Mark: - XLFormDescriptorCell
    
    override func formDescriptorCellCanBecomeFirstResponder() -> Bool {
        return rowDescriptor?.isDisabled() == false
    }
    
    override func formDescriptorCellBecomeFirstResponder() -> Bool {
        if isFirstResponder {
            resignFirstResponder()
            return false
        }
        return becomeFirstResponder()
    }
    
    override func update() {
        super.update()
        accessoryType = .none
        editingAccessoryType = .none
        selectionStyle = .none
        textLabel?.text = rowDescriptor?.title
        detailTextLabel?.text = valueDisplayText()
    }

    override  func formDescriptorCellDidSelected(withForm controller: XLFormViewController!) {
        controller.tableView.deselectRow(at: controller.form.indexPath(ofFormRow: rowDescriptor!)!, animated: true)
    }
    
    func valueDisplayText() -> String? {
        if let value = rowDescriptor?.value {
            return (value as AnyObject).displayText()
        }
        return rowDescriptor?.noValueDisplayText
    }
}

class InlineSegmentedControl : XLFormBaseCell, XLFormInlineRowDescriptorCell {
    
    var inlineRowDescriptor : XLFormRowDescriptor?
    lazy var segmentedControl : UISegmentedControl = {
        return UISegmentedControl.autolayoutView() as! UISegmentedControl
    }()
    
    override func configure() {
        super.configure()
        selectionStyle = .none
        contentView.addSubview(segmentedControl)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[segmentedControl]-|", options: .alignAllCenterY, metrics: nil, views: ["segmentedControl": segmentedControl]))
        segmentedControl.addTarget(self, action: #selector(InlineSegmentedControl.valueChanged), for: .valueChanged)
    }
    
    override func update() {
        super.update()
        updateSegmentedControl()
        segmentedControl.selectedSegmentIndex = selectedIndex()
        segmentedControl.isEnabled = rowDescriptor?.isDisabled() == false
    }
    
    //MARK: Actions
    
    func valueChanged() {
        inlineRowDescriptor!.value = inlineRowDescriptor!.selectorOptions![segmentedControl.selectedSegmentIndex]
        formViewController().updateFormRow(inlineRowDescriptor)
    }
    
    //MARK: Helpers
    
    func getItems() -> NSMutableArray {
        let result = NSMutableArray()
        for option in inlineRowDescriptor!.selectorOptions! {
            result.add((option as AnyObject).displayText())
        }
        return result
    }
    
    func updateSegmentedControl() {
        segmentedControl.removeAllSegments()
        getItems().enumerateObjects({ [weak self] (object, index, stop) in
            self?.segmentedControl.insertSegment(withTitle: (object as AnyObject).displayText(), at: index, animated: false)
        })
    }
    
    func selectedIndex() -> Int {
        let formRow = inlineRowDescriptor ?? rowDescriptor
        if let value = formRow?.value as? NSObject {
            for option in (formRow?.selectorOptions)! {
                if ((option as! NSObject).valueData() as AnyObject) === (value.valueData() as AnyObject) {
                    return formRow?.selectorOptions?.index(where: { ($0 as! NSObject) == (option as! NSObject) } ) ?? -1
                }
            }
        }
        return -1
    }
}
