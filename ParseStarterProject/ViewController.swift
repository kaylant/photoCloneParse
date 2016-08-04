/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // set up spinner size and center
    @IBAction func pause(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    @IBAction func restore(sender: AnyObject) {
        
        activityIndicator.stopAnimating()
        // UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    
    @available(iOS 8.0, *)
    @IBAction func createAlert(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Hey there!", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
        
            self.dismissViewControllerAnimated(true, completion:nil)
        
        }))
        
        // present view controller to user
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]! ) {
        
        print("Image Selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        importedImage.image = image
    }
    
    @IBAction func importImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    @IBOutlet var importedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve images from camera
        
        
        
        
        
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
//            print("Object has been saved.")
//        }
        
//        var product = PFObject(className: "Products")
//        
//        product["name"] = "Ice Cream"
//        
//        product["description"] = "Mint chocolate chip"
//        
//        product["price"] = 4.99
//        
//        product.saveInBackgroundWithBlock { (success, error) in
//            if success == true {
//                print("Object with ID \(product.objectId)")
//                
//            
//            } else {
//            
//                print("fail")
//                print(error)
//            
//            }
//        }
        
        /*
        // can use item ID to retreive saved item
        var query = PFQuery(className: "Products")
        
        query.getObjectInBackgroundWithId("pJ77fHq1wt", block: { (object: PFObject?, error: NSError? ) in
        
            if error != nil {
            
                print(error)
            
            // DOWNLOAD PRODUCT FROM PARSE AND UPDATE ITS INFORMATION
            // if we can create a variable called product equal to our object
            } else if let product = object {
            
                product["description"] = "Rocky Road"
                
                product["price"] = 5.99
                
                product.saveInBackground()
                
                // print(object!.objectForKey("description"))
            
            }
            
        })

        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
