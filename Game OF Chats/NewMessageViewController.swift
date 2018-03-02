//
//  NewMessageViewController.swift
//  Game OF Chats
//
//  Created by Parth Lamba on 28/02/18.
//  Copyright © 2018 Parth Lamba. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {

    let cellId = "CellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self , action: #selector(handleCancle))
        
        let navTitle = "New Conversation"
        navigationItem.title = navTitle
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: {
            (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]{
                let user = User()
                
                /*The below methos works to het the user data from Firebase but might crash if the user dtattype doesnot exactly mathc with the firevase database dtattypes and this could be a problem so to handle this we can use
                 * user.name = dictionary["name"] as? String
                 * user.email = dictionary["email"] as? String
                 */
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                /*The below command will cause the application to crash if used diectly therefore we need to use DispatchQueue.main.asych*/
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //print(user.name, user.email)
            }
            
            //print(snapshot)
        
        },withCancel: nil)
    }
    
    func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell  = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        if let userProfileImageURL = user.profileImage {
            
            cell.profileImageView.loadImageUsingCacheUsingUrlString(urlString: userProfileImageURL)
            
            /*let url = URL(string: userProfileImageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    let alert = UIAlertController(title: "OOPs!!", message: "Could not select the image", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    return
                }
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data!)
                }
            }).resume()*/
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0 //Choose your custom row height
    }
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 66, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 66, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    let profileImageView: UIImageView  = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "profile1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
        addSubview(profileImageView)
        
        //constraints For the image
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
