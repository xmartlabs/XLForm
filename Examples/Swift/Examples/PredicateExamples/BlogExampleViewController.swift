//
//  BlogExampleViewController.swift
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




class BlogExampleViewController : XLFormViewController {

    private enum Tags : String {
        case Hobbies = "hobbies"
        case Sport = "sport"
        case Film = "films1"
        case Film2 = "films2"
        case Music = "music"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Blog Example: Hobbies")
        
        section = XLFormSectionDescriptor()
        section.title = "Hobbies"
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Hobbies.rawValue, rowType: XLFormRowDescriptorTypeMultipleSelector, title:"Select Hobbies")
        row.selectorOptions = ["Sport", "Music", "Films"]
        row.value = []
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "Some more questions"
        section.hidden = NSPredicate(format: "$\(row.description).value.@count == 0")
        section.footerTitle = "BlogExampleViewController.swift"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Sport.rawValue, rowType: XLFormRowDescriptorTypeTextView, title:"Your favourite sportsman?")
        row.hidden = "NOT $\(Tags.Hobbies.rawValue).value contains 'Sport'"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Film.rawValue, rowType:XLFormRowDescriptorTypeTextView, title: "Your favourite film?")
        row.hidden = "NOT $\(Tags.Hobbies.rawValue) contains 'Films'"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Film2.rawValue, rowType:XLFormRowDescriptorTypeTextView, title:"Your favourite actor?")
        row.hidden = "NOT $\(Tags.Hobbies.rawValue) contains 'Films'"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Music.rawValue, rowType:XLFormRowDescriptorTypeTextView, title:"Your favourite singer?")
        row.hidden = "NOT $\(Tags.Hobbies.rawValue) contains 'Music'"
        section.addFormRow(row)
        
        self.form = form
    }
    
}
