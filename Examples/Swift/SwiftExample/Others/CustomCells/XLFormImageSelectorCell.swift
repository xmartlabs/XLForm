//
//  XLFormImageSelectorCell.swift
//  SwiftExample
//
//  Created by Matthew Goldspink on 9/9/15.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//

import MobileCoreServices

let XLFormImageSelectorCellDefaultImage = "defaultImage";
let XLFormImageSelectorCellImageRequest = "imageRequest";

typealias KVOContext = UInt8
var ObservationContext = KVOContext()


class XLFormImageSelectorCell : XLFormBaseCell, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private var defaultImage: UIImage?;
    private var imageRequest: NSURLRequest?;
    private var imageHeight: Float = 100.0;
    private var imageWidth: Float = 100.0;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configure() {
        super.configure()
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        self.separatorInset = UIEdgeInsetsZero;
        self.contentView.addSubview(self.imageView!)
        self.contentView.addSubview(self.textLabel!)
        self.addLayoutConstraints()
        let options = NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old
        self.textLabel!.addObserver(self, forKeyPath:"text", options:options, context:&ObservationContext)
    }
    
    override func update() {
        self.textLabel!.text = self.rowDescriptor.title;
        self.imageView!.image = self.rowDescriptor.value != nil ? self.rowDescriptor.value as! UIImage? : self.defaultImage
        let imageRequestNotNil = self.imageRequest != nil
        let rowDescriptorNil = self.rowDescriptor.value == nil
        if (imageRequestNotNil && rowDescriptorNil) {
            self.imageView!.setImageWithURLRequest(self.imageRequest!,
                placeholderImage:self.defaultImage,
                success:{ [weak self] (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                    let rowDescriptorNil = self?.rowDescriptor.value != nil
                    if (rowDescriptorNil && image != nil){
                        self?.imageView!.image = image
                    }
                }, failure:{ [weak self] (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                    println("Failed to download image")
                })
        }
    }
    
    override class func formDescriptorCellHeightForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 120.0
    }
    
    override func formDescriptorCellDidSelectedWithFormController(controller: XLFormViewController!) {
        let alertController = UIAlertController(title: self.rowDescriptor.selectorTitle,
                                    message:nil,
                                    preferredStyle:.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel",
                                    style:.Cancel,
                                    handler:nil))
        
        let existingPhotoAction = UIAlertAction(title: NSLocalizedString("XLFormImageSelectorCell_ChooseExistingPhoto", value:"Choose Existing Photo", comment:"Choose Existing Photo"),
            style: .Default) {[weak self] (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .PhotoLibrary
                imagePickerController.mediaTypes = [kUTTypeImage]
                self?.formViewController().presentViewController(imagePickerController, animated:true, completion: nil)
            }
        alertController.addAction(existingPhotoAction)
        
        let takePictureAction = UIAlertAction(title: NSLocalizedString("XLFormImageSelectorCell_TakePicture", value:"Take a Picture", comment:"Take a Picture"),
            style: .Default) {[weak self] (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .Camera
                imagePickerController.mediaTypes = [kUTTypeImage]
                self?.formViewController().presentViewController(imagePickerController,
                    animated:true,
                    completion:nil)
            }
        
        alertController.addAction(takePictureAction)
    
        self.formViewController().presentViewController(alertController, animated:true, completion:nil)
    }
    
    /// MARK: LayoutConstraints
    
    func addLayoutConstraints() {

        let uiComponents = [ "image" : self.imageView!, "text" : self.textLabel!]
        
        let metrics = ["margin": 5.0]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(margin)-[text]", options:nil, metrics:metrics, views:uiComponents))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(margin)-[text]", options:nil, metrics:metrics, views:uiComponents))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imageView!,
            attribute:.Top,
            relatedBy:.Equal,
            toItem:self.contentView,
            attribute:.Top,
            multiplier:1.0,
            constant:10.0))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imageView!,
            attribute:.Bottom,
            relatedBy:.Equal,
            toItem:self.contentView,
            attribute:.Bottom,
            multiplier:1.0,
            constant:-10.0))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image(width)]", options:nil, metrics:[ "width" : self.imageWidth ], views:uiComponents))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.imageView!,
            attribute:.CenterX,
            relatedBy:.Equal,
            toItem:self.contentView,
            attribute:.CenterX,
            multiplier:1.0,
            constant:0.0))
    }
    
    func setImageValue(image: UIImage) {
        self.rowDescriptor.value = image
        self.imageView!.image = image
    }
    
    /// MARK: KVO
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (object as! UILabel == self.textLabel! && keyPath == "text") {
            let raw = UInt(change[NSKeyValueChangeKindKey]!.integerValue)
            if (NSKeyValueChange(rawValue: raw)! == NSKeyValueChange.Setting) {
                self.contentView.needsUpdateConstraints()
            }
        }
    }
    
    deinit {
        self.textLabel!.removeObserver(self, forKeyPath:"text")
    }
    
    /// MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            if (editedImage != nil) {
                self.setImageValue(editedImage!)
            } else {
              let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
              if (originalImage != nil) {
                self.setImageValue(originalImage!)
              }
            }
    
            self.formViewController().dismissViewControllerAnimated(true, completion:nil)
    }
    
    // MARK: Properties
    private var _imageView: UIImageView?
    override var imageView: UIImageView? {
        get {
            if (_imageView != nil) {
                return _imageView
            }
            _imageView = UIImageView.autolayoutView() as? UIImageView
            _imageView?.layer.masksToBounds = true
            _imageView?.contentMode = .ScaleAspectFit
            _imageView?.layer.cornerRadius = CGFloat(self.imageHeight) / CGFloat(2.0)
            return _imageView
        }
        set {
            _imageView = newValue
        }
    }
    
    private var _textLabel: UILabel?
    override var textLabel: UILabel? {
        get {
            if (_textLabel != nil) {
                return _textLabel
            }
            _textLabel = UILabel.autolayoutView() as? UILabel
            return _textLabel
        }
        set {
            _textLabel = newValue
        }
    }
    
    
    func setDefaultImage(defaultImage: UIImage) {
        self.defaultImage = defaultImage
    }
    
    
    func setImageRequest(imageRequest: NSURLRequest) {
        self.imageRequest = imageRequest
    }
}