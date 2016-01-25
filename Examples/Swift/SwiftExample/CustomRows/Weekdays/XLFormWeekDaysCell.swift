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
    
    enum kWeekDay: Int {
        case
        Sunday = 1,
        Monday,
        Tuesday,
        Wednesday,
        Thursday,
        Friday,
        Saturday
        
        func description() -> String {
            switch self {
            case .Sunday:
                return "Sunday"
            case .Monday:
                return "Monday"
            case .Tuesday:
                return "Tuesday"
            case .Wednesday:
                return "Wednesday"
            case .Thursday:
                return "Thursday"
            case .Friday:
                return "Friday"
            case .Saturday:
                return "Saturday"
            }
        }
        
        //Add Custom Functions 
        
        //Allows for iteration as needed (for in ...)
        static let allValues = [Sunday,
                                Monday,
                                Tuesday,
                                Wednesday,
                                Thursday,
                                Friday,
                                Saturday]
    }
    
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
        selectionStyle = .None
        configureButtons()
    }
    
    
    override func update() {
        super.update()
        updateButtons()
    }
    
    override static func formDescriptorCellHeightForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 60
    }
    
//MARK: - Action
    
    @IBAction func dayTapped(sender: UIButton) {
        let day = getDayFormButton(sender)
        sender.selected = !sender.selected
        var newValue = rowDescriptor!.value as! Dictionary<String, Bool>
        newValue[day] = sender.selected
        rowDescriptor!.value = newValue
    }
    
//MARK: - Helpers
    
    func configureButtons() {
        for subview in contentView.subviews {
            if let button = subview as? UIButton {
                button.setImage(UIImage(named: "uncheckedDay"), forState: .Normal)
                button.setImage(UIImage(named: "checkedDay"), forState: .Selected)
                button.adjustsImageWhenHighlighted = false
                imageTopTitleBottom(button)
            }
        }
    
    }
    
    func updateButtons() {
		var value = rowDescriptor!.value as! Dictionary<String, Bool>

        sundayButton.selected = value[kWeekDay.Sunday.description()]!
        mondayButton.selected = value[kWeekDay.Monday.description()]!
        tuesdayButton.selected = value[kWeekDay.Tuesday.description()]!
        wednesdayButton.selected = value[kWeekDay.Wednesday.description()]!
        thursdayButton.selected = value[kWeekDay.Thursday.description()]!
        fridayButton.selected = value[kWeekDay.Friday.description()]!
        saturdayButton.selected = value[kWeekDay.Saturday.description()]!
        
        sundayButton.alpha = rowDescriptor!.isDisabled() ? 0.6 : 1
        mondayButton.alpha = mondayButton.alpha
        tuesdayButton.alpha = mondayButton.alpha
        wednesdayButton.alpha = mondayButton.alpha
        thursdayButton.alpha = mondayButton.alpha
        fridayButton.alpha = mondayButton.alpha
        saturdayButton.alpha = mondayButton.alpha
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
        let titleSize : CGSize = (button.titleLabel!.text! as NSString).sizeWithAttributes([NSFontAttributeName: button.titleLabel!.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
    }
    
    func getDayFormButton(button: UIButton) -> String {
        switch button {
        case sundayButton:
            return kWeekDay.Sunday.description()
        case mondayButton:
            return kWeekDay.Monday.description()
        case tuesdayButton:
            return kWeekDay.Tuesday.description()
        case wednesdayButton:
            return kWeekDay.Wednesday.description()
        case thursdayButton:
            return kWeekDay.Thursday.description()
        case fridayButton:
            return kWeekDay.Friday.description()
        default:
            return kWeekDay.Saturday.description()
        }
    }
    
}

