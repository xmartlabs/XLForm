//
//  DateAndTimeValueTransformer.swift
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



class DateValueTrasformer : NSValueTransformer {

    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let valueData: AnyObject = value {
            if valueData.isKindOfClass(NSDate) {
                let date = valueData as! NSDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
                return dateFormatter.stringFromDate(date)
            }
        }
        return nil
    }
}


class DateTimeValueTrasformer: NSValueTransformer {

    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }


    override class func allowsReverseTransformation() -> Bool {
        return false
    }

    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let valueData: AnyObject = value {
            if valueData.isKindOfClass(NSDate) {
                let date = valueData as! NSDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                return dateFormatter.stringFromDate(date)
            }
        }
        return nil
    }
}
