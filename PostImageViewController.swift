//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Kaylan Smith on 8/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)
class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        // user will tap when they want to upload an image
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        
    }
    
    func compressForUpload(original:UIImage, withHeightLimit heightLimit:CGFloat, andWidthLimit widthLimit:CGFloat)->UIImage{
        
        let originalSize = original.size
        var newSize = originalSize
        
        if originalSize.width > widthLimit && originalSize.width > originalSize.height {
            
            newSize.width = widthLimit
            newSize.height = originalSize.height*(widthLimit/originalSize.width)
        } else if originalSize.height > heightLimit && originalSize.height > originalSize.width {
            
            newSize.height = heightLimit
            newSize.width = originalSize.width*(heightLimit/originalSize.height)
        }
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize)
        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return compressedImage
    }
    
    @IBOutlet var message: UITextField!
    
    
    @IBAction func postImage(sender: AnyObject) {
    
        // show user is uploading something
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // stop user from interacting while activity indicator is running
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        // upload to parse
        var post = PFObject(className: "Post")
        post["message"] = message.text
        post["userId"] = PFUser.currentUser()!.objectId!
        
        // convert image to file to save it
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Image posted!", message: "Your image has been posted successfully")
            
                // resets so user is ready to post another image
                self.imageToPost.image = UIImage(named: "default-placeholder.png")
                
                self.message.text = ""
                
            } else {
            
                self.displayAlert("Could not post image", message: "Please try again")
            
            }
            
        }
        
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
