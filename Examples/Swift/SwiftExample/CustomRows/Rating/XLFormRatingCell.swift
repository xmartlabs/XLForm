//  XLFormRatingCell.swift
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


let XLFormRowDescriptorTypeRate = "XLFormRowDescriptorTypeRate"


class XLFormRatingCell : XLFormBaseCell {
    
    @IBOutlet weak var rateTitle: UILabel!
    @IBOutlet weak var ratingView: XLRatingView!
    
        
    override func configure() {
        super.configure()
        selectionStyle = .none
        ratingView.addTarget(self, action: #selector(XLFormRatingCell.rateChanged(_:)), for:.valueChanged)
    }
    
    
    override func update() {
        super.update()
        ratingView.value = (rowDescriptor!.value! as AnyObject).floatValue
        rateTitle.text = rowDescriptor!.title
        ratingView.alpha = rowDescriptor!.isDisabled() ? 0.6 : 1
        rateTitle.alpha = rowDescriptor!.isDisabled() ? 0.6 : 1
    }
    
//MARK: Events
    
    func rateChanged(_ ratingView : XLRatingView){
        rowDescriptor!.value = ratingView.value
    }
    
}
