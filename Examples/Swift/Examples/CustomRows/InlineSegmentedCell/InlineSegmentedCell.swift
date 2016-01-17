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
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        if isFirstResponder() {
            return super.becomeFirstResponder()
        }
        let result = super.becomeFirstResponder()
        if result {
            let inlineRowDescriptor : XLFormRowDescriptor = XLFormRowDescriptor(tag: nil, rowType: XLFormViewController.inlineRowDescriptorTypesForRowDescriptorTypes()![rowDescriptor!.rowType] as! String)
            let cell = inlineRowDescriptor.cellForFormController(formViewController())
            let inlineCell = cell as? XLFormInlineRowDescriptorCell
            inlineCell?.inlineRowDescriptor = rowDescriptor
            rowDescriptor?.sectionDescriptor.addFormRow(inlineRowDescriptor, afterRow: rowDescriptor!)
            formViewController().ensureRowIsVisible(inlineRowDescriptor)
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        if isFirstResponder() {
            return super.resignFirstResponder()
        }
        let selectedRowPath : NSIndexPath = formViewController().form.indexPathOfFormRow(rowDescriptor!)!
        let nextRowPath = NSIndexPath(forRow: selectedRowPath.row + 1, inSection: selectedRowPath.section)
        let nextFormRow = formViewController().form.formRowAtIndex(nextRowPath)
        let section : XLFormSectionDescriptor = formViewController().form.formSectionAtIndex(UInt(nextRowPath.section))!
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
        if isFirstResponder() {
            resignFirstResponder()
            return false
        }
        return becomeFirstResponder()
    }
    
    override func update() {
        super.update()
        accessoryType = .None
        editingAccessoryType = .None
        selectionStyle = .None
        textLabel?.text = rowDescriptor?.title
        detailTextLabel?.text = valueDisplayText()
    }

    override  func formDescriptorCellDidSelectedWithFormController(controller: XLFormViewController!) {
        controller.tableView.deselectRowAtIndexPath(controller.form.indexPathOfFormRow(rowDescriptor!)!, animated: true)
    }
    
    func valueDisplayText() -> String? {
        if let value = rowDescriptor?.value {
            return value.displayText()
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
        selectionStyle = .None
        contentView.addSubview(segmentedControl)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[segmentedControl]-|", options: .AlignAllCenterY, metrics: nil, views: ["segmentedControl": segmentedControl]))
        segmentedControl.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)
    }
    
    override func update() {
        super.update()
        updateSegmentedControl()
        segmentedControl.selectedSegmentIndex = selectedIndex()
        segmentedControl.enabled = rowDescriptor?.isDisabled() == false
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
            result.addObject(option.displayText())
        }
        return result
    }
    
    func updateSegmentedControl() {
        segmentedControl.removeAllSegments()
        getItems().enumerateObjectsUsingBlock { [weak self] object, index, stop in
            self?.segmentedControl.insertSegmentWithTitle(object.displayText(), atIndex: index, animated: false)
        }
    }
    
    func selectedIndex() -> Int {
        let formRow = inlineRowDescriptor ?? rowDescriptor
        if let value = formRow?.value {
            for option in (formRow?.selectorOptions)! {
                if option.valueData().isEqual(value.valueData()){
                    return formRow?.selectorOptions?.indexOf({ $0.isEqual(option) }) ?? -1
                }
            }
        }
        return -1
    }
}