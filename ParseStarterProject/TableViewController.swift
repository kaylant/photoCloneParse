//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Kaylan Smith on 8/9/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    // download user list
    var usernames = [""]
    var userids = [""]
    var isFollowing = ["":false]
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            
            if let users = objects {
                
                // clears the array first from past sessions
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        // only add the user if it is not the current user
                        if user.objectId != PFUser.currentUser()?.objectId {
                            
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            
                            // check if user is following someone already
                            var query = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                                
                                if let objects = objects {
                                    
                                    if objects.count > 0 {
                                        
                                        self.isFollowing[user.objectId!] = true
                                        
                                    } else {
                                        
                                        self.isFollowing[user.objectId!] = false
                                        
                                    }
                                    
                                }
                                
                                if self.isFollowing.count == self.usernames.count {
                                    
                                    self.tableView.reloadData()
                                    
                                    self.refresher.endRefreshing()

                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            }
            

        })
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull down to refresh
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")

        refresher.addTarget(self, action: #selector(TableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        
        // set up a variable to hold user id
        // using that to check if user is following another user
        let followedObjectId = userids[indexPath.row]
        
        if isFollowing[followedObjectId] == true {
         
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // follow another user
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let followedObjectId = userids[indexPath.row]
        
        // check to see if already follwing a user
        if isFollowing[followedObjectId] == false {
            
            isFollowing[followedObjectId] = true
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            var following = PFObject(className: "followers")
            following["following"] = userids[indexPath.row]
            following["follower"] = PFUser.currentUser()?.objectId
            
            following.saveInBackground()
            
        } else {
        
            isFollowing[followedObjectId] = false
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            // check if user is following someone already
            // tap a user to unfollow
            var query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            query.whereKey("following", equalTo: userids[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) in
                
                if let objects = objects {
                    
                    for object in objects {
                    
                        object.deleteInBackground()
                    
                    }
                    
                }

                
            })

        }
    }

}
