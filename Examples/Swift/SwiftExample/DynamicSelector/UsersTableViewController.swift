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
        tempUserImage.translatesAutoresizingMaskIntoConstraints = false
        tempUserImage.layer.masksToBounds = true
        tempUserImage.layer.cornerRadius = 10.0
        return tempUserImage
    }()

    
    lazy var userName : UILabel = {
        let tempUserName = UILabel()
        tempUserName.translatesAutoresizingMaskIntoConstraints = false
        tempUserName.font = UIFont.systemFont(ofSize: 15.0)
        return tempUserName
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    
        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addConstraints(layoutConstraints())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
// MARK: - Layout Constraints

    func layoutConstraints() -> [NSLayoutConstraint]{
        let views = ["image": self.userImage, "name": self.userName ] as [String : Any]
        let metrics = [ "imgSize": 50.0, "margin": 12.0]
        
        var result = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[image(imgSize)]-[name]", options:.alignAllTop, metrics: metrics, views: views)
        result += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(margin)-[image(imgSize)]", options:NSLayoutFormatOptions(), metrics:metrics, views: views)
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
        let jsonData = dataString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        do {
            let result = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! Array<AnyObject>
            return result
        }
        catch let error as NSError {
            print("\(error)")
        }
        return nil
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
    
    func formDisplayText() -> String {
        return self.userName
    }

    func formValue() -> Any {
        return self.userId as Any
    }
    
}

class UsersTableViewController : UITableViewController, XLFormRowDescriptorViewController, XLFormRowDescriptorPopoverViewController {

    
    var rowDescriptor : XLFormRowDescriptor?
    var popoverController : UIPopoverController?
    
    var userCell : UserCell?
    
    fileprivate let kUserCellIdentifier = "UserCell"
    
    
    override init(style: UITableViewStyle) {
        super.init(style: style);
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: kUserCellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
// MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersJSONSerialization.sharedInstance.userData!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: self.kUserCellIdentifier, for: indexPath) as! UserCell
        let usersData = UsersJSONSerialization.sharedInstance.userData! as! Array<Dictionary<String, AnyObject>>
        let userData = usersData[(indexPath as NSIndexPath).row] as Dictionary<String, AnyObject>
        let userId = userData["id"] as! Int
        cell.userName.text = userData["name"] as? String
        cell.userImage.image = UIImage(named: (userData["imageName"] as? String)!)
        if let value = rowDescriptor?.value {
            cell.accessoryType = ((value as? XLFormOptionObject)?.formValue() as? Int) == userId ? .checkmark : .none
        }
        return cell;

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73.0
    }
    

//MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usersData = UsersJSONSerialization.sharedInstance.userData! as! Array<Dictionary<String, AnyObject>>
        let userData = usersData[(indexPath as NSIndexPath).row] as Dictionary<String, AnyObject>
        let user = User(userId: (userData["id"] as! Int), userName: userData["name"] as! String, userImage: userData["imageName"] as! String)
        self.rowDescriptor!.value = user;
        if let porpOver = self.popoverController {
            porpOver.dismiss(animated: true)
            porpOver.delegate?.popoverControllerDidDismissPopover!(porpOver)
        }
        else if parent is UINavigationController {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}
