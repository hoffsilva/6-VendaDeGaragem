//
//  LoginViewController.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 23/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class UserViewController: UIViewController {

    
    
   @IBOutlet weak var navItem: UINavigationItem!
    let buttonFacebook = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
       verifyIfUserIslogged()
    }
    
    func drawFacebbokButtonOnNavItem(size : Bool){
        buttonFacebook.frame = CGRectMake(0, 0, 0, 0)
        if size == true {
            buttonFacebook.setImage(UIImage(named: "facebookOnline"), forState: .Normal)
            buttonFacebook.addTarget(self, action: #selector(loginButtonClicked), forControlEvents: .TouchDown)
            buttonFacebook.sizeToFit()
            let barButtonFacebook = UIBarButtonItem(customView: buttonFacebook)
            self.navigationController?.navigationItem.leftBarButtonItem = barButtonFacebook
            self.navItem.leftBarButtonItem = barButtonFacebook
            addButton()
        }else{
            buttonFacebook.setImage(UIImage(named: "facebookOffline"), forState: .Normal)
            buttonFacebook.addTarget(self, action: #selector(loginButtonClicked), forControlEvents: .TouchDown)
            buttonFacebook.sizeToFit()
            let barButtonFacebook = UIBarButtonItem(customView: buttonFacebook)
            self.navItem.rightBarButtonItem = barButtonFacebook
        }
    }
    
    func loginButtonClicked() {
       
        let login = FBSDKLoginManager()
        
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            login.logInWithReadPermissions(["public_profile"], fromViewController: self) { ( flmlr, error) in
                if ((error) != nil) {
                    NSLog("Process error");
                } else if (flmlr.isCancelled) {
                    NSLog("Cancelled");
                } else {
                    NSLog("Logged in");
                    print(flmlr.description)
                    self.drawFacebbokButtonOnNavItem(true)
                    self.addButton()
                }
            }
            
        }else{
        
            login.logOut()
            drawFacebbokButtonOnNavItem(false)
        }
        
    }
    
    
    func addButton() {
        self.navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addVenda:")
    }
    
    func addVenda(sender: UIButton) {
        print("chamaou!")
        performSegueWithIdentifier("addVenda", sender: view)
    }
    
    func verifyIfUserIslogged(){
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            drawFacebbokButtonOnNavItem(false)
            
            print("not logged in")
        }
        else{
            print("logged in already")
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id"], HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                if(error == nil)
                {
                    print("result \(result)")
                }
                else
                {
                    print("error \(error)")
                }
            })
            
            drawFacebbokButtonOnNavItem(true)
        }

    }
    
    

}
