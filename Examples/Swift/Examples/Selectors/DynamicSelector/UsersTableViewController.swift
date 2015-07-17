//
//  UsersTableViewController.swift
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


class UserCell : UITableViewCell {

    lazy var userImage : UIImageView = {
        let tempUserImage = UIImageView()
        tempUserImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        tempUserImage.layer.masksToBounds = true
        tempUserImage.layer.cornerRadius = 10.0
        return tempUserImage
    }()

    
    lazy var userName : UILabel = {
        let tempUserName = UILabel()
        tempUserName.setTranslatesAutoresizingMaskIntoConstraints(false)
        tempUserName.font = UIFont.systemFontOfSize(15.0)
        return tempUserName
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    
        self.contentView.addSubview(self.userImage)
        self.contentView.addSubview(self.userName)
    
        self.contentView.addConstraints(self.layoutConstraints())
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
// MARK: - Layout Constraints

    func layoutConstraints() -> [AnyObject]{
        let views = ["image": self.userImage, "name": self.userName ]
        let metrics = [ "imgSize": 50.0, "margin": 12.0]
        
        var result = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(margin)-[image(imgSize)]-[name]", options:NSLayoutFormatOptions.AlignAllTop, metrics: metrics, views: views)
        result += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(margin)-[image(imgSize)]", options:NSLayoutFormatOptions.allZeros, metrics:metrics, views: views)
        return result
    }
    
    
}


private let _UsersJSONSerializationSharedInstance = UsersJSONSerialization()

class UsersJSONSerialization {
    
    lazy var userData : Array<AnyObject>? = {
        let dataString =
        "[" +
        "{\"id\":1,\"name\":\"Apu Nahasapeemapetilon\",\"imageName\":\"Apu_Nahasapeemapetilon.png\"}," +
        "{\"id\":7,\"name\":\"Bart Simpsons\",\"imageName\":\"Bart_Simpsons.png\"}," +
        "{\"id\":8,\"name\":\"Homer Simpsons\",\"imageName\":\"Homer_Simpsons.png\"}," +
        "{\"id\":9,\"name\":\"Lisa Simpsons\",\"imageName\":\"Lisa_Simpsons.png\"}," +
        "{\"id\":2,\"name\":\"Maggie Simpsons\",\"imageName\":\"Maggie_Simpsons.png\"}," +
        "{\"id\":3,\"name\":\"Marge Simpsons\",\"imageName\":\"Marge_Simpsons.png\"}," +
        "{\"id\":4,\"name\":\"Montgomery Burns\",\"imageName\":\"Montgomery_Burns.png\"}," +
        "{\"id\":5,\"name\":\"Ned Flanders\",\"imageName\":\"Ned_Flanders.png\"}," +
        "{\"id\":6,\"name\":\"Otto Mann\",\"imageName\":\"Otto_Mann.png\"}]"
        let jsonData = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        return NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.allZeros, error: nil) as! Array<AnyObject>?
    }()
    
    class var sharedInstance: UsersJSONSerialization {
        return _UsersJSONSerializationSharedInstance
    }

    
}

class User: NSObject,  XLFormOptionObject {
    
    let userId: Int
    let userName : String
    let userImage: String
    
    init(userId: Int,  userName: String, userImage: String){
        self.userId = userId
        self.userImage = userImage
        self.userName = userName
    }
    
    func formDisplayText() -> String! {
        return self.userName
    }
    
    func formValue() -> AnyObject! {
        return self.userId
    }
    
}

class UsersTableViewController : UITableViewController, XLFormRowDescriptorViewController, XLFormRowDescriptorPopoverViewController {

    
    var rowDescriptor : XLFormRowDescriptor?
    var popoverController : UIPopoverController?
    
    var userCell : UserCell?
    
    private let kUserCellIdentifier = "UserCell"
    
    
    override init(style: UITableViewStyle) {
        super.init(style: style);
    }
    
    override init!(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UserCell.self, forCellReuseIdentifier: self.kUserCellIdentifier)
        self.tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
    }
    
// MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersJSONSerialization.sharedInstance.userData!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCellWithIdentifier(self.kUserCellIdentifier, forIndexPath: indexPath) as! UserCell
        let usersData = UsersJSONSerialization.sharedInstance.userData! as! Array<Dictionary<String, AnyObject>>
        let userData = usersData[indexPath.row] as Dictionary<String, AnyObject>
        let userId = userData["id"] as! Int
        cell.userName.text = userData["name"] as? String
        cell.userImage.image = UIImage(named: (userData["imageName"] as? String)!)
        if self.rowDescriptor?.value != nil {
            cell.accessoryType = self.rowDescriptor!.value.formValue().isEqual(userId) ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        }
        return cell;

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 73.0
    }
    

//MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let usersData = UsersJSONSerialization.sharedInstance.userData! as! Array<Dictionary<String, AnyObject>>
        let userData = usersData[indexPath.row] as Dictionary<String, AnyObject>
        let user = User(userId: (userData["id"] as! Int), userName: userData["name"] as! String, userImage: userData["imageName"] as! String)
        self.rowDescriptor!.value = user;
        if let porpOver = self.popoverController {
            porpOver.dismissPopoverAnimated(true)
            porpOver.delegate?.popoverControllerDidDismissPopover!(porpOver)
        }
        else if self.parentViewController is UINavigationController {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
}
