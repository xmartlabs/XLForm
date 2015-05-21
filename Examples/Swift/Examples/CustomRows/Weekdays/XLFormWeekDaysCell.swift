//  XLFormWeekDaysCell.swift
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


let XLFormRowDescriptorTypeWeekDays = "XLFormRowDescriptorTypeWeekDays"


class XLFormWeekDaysCell : XLFormBaseCell {
    
    static let kSunday = "sunday"
    static let kMonday = "monday"
    static let kTuesday = "tuesday"
    static let kWednesday = "wednesday"
    static let kThursday = "thursday"
    static let kFriday = "friday"
    static let kSaturday = "saturday"
    
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!

//MARK: - XLFormDescriptorCell
    
    override func configure() {
        super.configure()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.configureButtons()
    }
    
    
    override func update() {
        super.update()
        self.updateButtons()
    }
    
    override static func formDescriptorCellHeightForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 60
    }
    
//MARK: - Action
    
    @IBAction func dayTapped(sender: UIButton) {
        let day = self.getDayFormButton(sender)
        sender.selected = !sender.selected
        var newValue = self.rowDescriptor.value as! Dictionary<String, Bool>
        newValue[day] = sender.selected
        self.rowDescriptor.value = newValue
    }
    
//MARK: - Helpers
    
    func configureButtons() {
        for subview in self.contentView.subviews {
            if let button : UIButton = subview as? UIButton {
                button.setImage(UIImage(named: "uncheckedDay"), forState: UIControlState.Normal)
                button.setImage(UIImage(named: "checkedDay"), forState: UIControlState.Selected)
                button.adjustsImageWhenHighlighted = false
                self.imageTopTitleBottom(button)
            }
        }
    
    }
    
    func updateButtons() {
        let value = self.rowDescriptor.value as! Dictionary<String, Bool>
        self.sundayButton.selected = value[XLFormWeekDaysCell.kSunday]!
        self.mondayButton.selected = value[XLFormWeekDaysCell.kMonday]!
        self.tuesdayButton.selected = value[XLFormWeekDaysCell.kTuesday]!
        self.wednesdayButton.selected = value[XLFormWeekDaysCell.kWednesday]!
        self.thursdayButton.selected = value[XLFormWeekDaysCell.kThursday]!
        self.fridayButton.selected = value[XLFormWeekDaysCell.kFriday]!
        self.saturdayButton.selected = value[XLFormWeekDaysCell.kSaturday]!
        
        self.sundayButton.alpha = self.rowDescriptor.isDisabled() ? 0.6 : 1
        self.mondayButton.alpha = self.mondayButton.alpha
        self.tuesdayButton.alpha = self.mondayButton.alpha
        self.wednesdayButton.alpha = self.mondayButton.alpha
        self.thursdayButton.alpha = self.mondayButton.alpha
        self.fridayButton.alpha = self.mondayButton.alpha
        self.saturdayButton.alpha = self.mondayButton.alpha
    }
    
    func imageTopTitleBottom(button: UIButton) {
        // the space between the image and text
        let spacing : CGFloat = 3.0
        
        // lower the text and push it left so it appears centered
        //  below the image
        let imageSize : CGSize = button.imageView!.image!.size
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        
        // raise the image and push it right so it appears centered
        //  above the text
        let titleSize : CGSize = (button.titleLabel!.text as! NSString).sizeWithAttributes([NSFontAttributeName: button.titleLabel!.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
    }
    
    func getDayFormButton(button: UIButton) -> String
    {
        if button == self.sundayButton { return XLFormWeekDaysCell.kSunday }
        if button == self.mondayButton { return XLFormWeekDaysCell.kMonday }
        if button == self.tuesdayButton { return XLFormWeekDaysCell.kTuesday }
        if button == self.wednesdayButton { return XLFormWeekDaysCell.kWednesday }
        if button == self.thursdayButton { return XLFormWeekDaysCell.kThursday }
        if button == self.fridayButton { return XLFormWeekDaysCell.kFriday }
        return XLFormWeekDaysCell.kSaturday
    }
    
}

