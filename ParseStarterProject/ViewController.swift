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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
