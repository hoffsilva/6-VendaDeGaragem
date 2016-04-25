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

class LoginViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addTapped")
//        navigationItem.setRightBarButtonItem(loginButton, animated: true)
//        loginButton.center = self.view.center
//        self.view.addSubview(loginButton)
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        
        
//        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTapped")
//        let play = UIBarButtonItem(title: "Play", style: .Plain, target: self, action: "addTapped")
//        
//        navigationItem.leftBarButtonItems = [add, play]
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
