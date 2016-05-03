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

class UserTableViewController: UITableViewController {

    var idOfFacebook = String()
    var vendaPersistence = VendaPersistence()
    var vendasOfUser = [Vendas]()
    var parse = ParseConvenience()
    var overlayView = UIView()
    
    var activityIndicator = UIActivityIndicatorView()
    
   @IBOutlet weak var navItem: UINavigationItem!
    let buttonFacebook = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTableView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
       verifyIfUserIslogged()
        reloadTableView()
        dispatch_async(dispatch_get_main_queue()) { 
            self.reloadTableView()
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendasOfUser.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("vendaCell", forIndexPath: indexPath) as! VendaTableViewCell
        
        cell.labelNome.text = "\(vendasOfUser[indexPath.row].nome)"
        cell.labelData.text = "\(vendasOfUser[indexPath.row].data)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        actionDetailVenda()
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func drawFacebbokButtonOnNavItem(size : Bool){
        buttonFacebook.frame = CGRectMake(0, 0, 0, 0)
        if size == true {
            managerFacebookLoginButtonAndNavItem("Minhas Vendas", imageOfButton: "facebookOnline")
            addButton()
        }else{
            
            managerFacebookLoginButtonAndNavItem("Efetue Login", imageOfButton: "facebookOffline")
            vendasOfUser.removeAll()
            removeAddButton()
            reloadTableView()
        }
    }
    
    func managerFacebookLoginButtonAndNavItem(titleOfNavItem: String, imageOfButton: String){
        buttonFacebook.setImage(UIImage(named: imageOfButton), forState: .Normal)
        buttonFacebook.addTarget(self, action: #selector(loginButtonClicked), forControlEvents: .TouchDown)
        buttonFacebook.sizeToFit()
        let barButtonFacebook = UIBarButtonItem(customView: buttonFacebook)
        self.navigationController?.navigationItem.leftBarButtonItem = barButtonFacebook
        self.navItem.leftBarButtonItem = barButtonFacebook
        self.navItem.title = titleOfNavItem

    }
    
    func vendasOfUser(id: String){
        vendasOfUser = vendaPersistence.buscarVendasDeUsuarios(id)
        reloadTableView()
    }
    
    
    func actionDetailVenda(){
        self.performSegueWithIdentifier("detalhaVenda", sender: view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detalhaVenda"{
            let indexPaths = tableView.indexPathForSelectedRow
            let nav  = segue.destinationViewController as! UINavigationController
            let detalharVenda = nav.topViewController as! DetalhVendaTableViewController
            detalharVenda.venda = vendasOfUser[(indexPaths?.row)!]
            print("Detalhou!")
        }else if segue.identifier == "addVenda"{
            let nav  = segue.destinationViewController as! UINavigationController
            let view = nav.viewControllers.first as? AddSaleTableViewController
            
            view?.table = self
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        parse.deletarVenda(vendasOfUser[indexPath.row].id_azure) { (networkConectionError) in
            
            self.loadActivityIndicator()
            if networkConectionError == true{
               self.showAlert(":(", message: "Internet conection was lost or server is offline!", preferredSytle: UIAlertControllerStyle.Alert)
                self.overlayView.removeFromSuperview()
                return
            }else{
                CoreDataStackManager.sharedInstance().managedObjectContext.deleteObject(self.vendasOfUser[indexPath.row])
                
                self.vendasOfUser.removeAtIndex(indexPath.row)
                self.overlayView.removeFromSuperview()
                tableView.reloadData()
            }
            
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
                    
                    let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id"], HTTPMethod: "GET")
                    req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                        if(error == nil)
                        {
                            print("result \(result)")
                            if let idFacebook = result["id"]{
                                print(idFacebook)
                                self.idOfFacebook = (idFacebook as? String)!
                            }
                        }
                        else
                        {
                            self.showAlert("Facebook", message: "Internet conection was lost or server is offline!", preferredSytle: UIAlertControllerStyle.Alert)
                            print("error \(error)")
                        }
                    })
                    
                    
                    self.drawFacebbokButtonOnNavItem(true)
                    self.addButton()
                }
            }
            
        }else{
        
            login.logOut()
            drawFacebbokButtonOnNavItem(false)
        }
        
    }
    
    func reloadTableView() {
         tableView.reloadData()
    }
    
    func removeAddButton() {
        self.navItem.rightBarButtonItem = nil    }
    
    func addButton() {
        self.navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(UserTableViewController.addVenda(_:)))
    }
    
    func addVenda(sender: UIButton) {
        print("chamaou!")
        performSegueWithIdentifier("addVenda", sender: view)
    }
    
    func verifyIfUserIslogged(){
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            drawFacebbokButtonOnNavItem(false)
            reloadTableView()
            print("not logged in")
            
        }
        else{
            print("logged in already")
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id"], HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                if(error == nil)
                {
                    print("result \(result)")
                    if let idFacebook = result["id"]{
                        print(idFacebook)
                        var teste = "\(idFacebook!)"
                        self.vendasOfUser(teste)
                    }
                }
                else
                {
                    self.showAlert("Facebook", message: "Internet conection was lost or server is offline!", preferredSytle: UIAlertControllerStyle.Alert)
                    print("error \(error)")
                }
            })
            
            drawFacebbokButtonOnNavItem(true)
        }

    }
    
    func loadActivityIndicator(){
        self.overlayView = UIView(frame: self.tableView.bounds)
        self.overlayView.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 0.5)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.activityIndicator.alpha = 1.0;
        self.activityIndicator.center = self.view.center;
        self.activityIndicator.hidesWhenStopped = true;
        self.overlayView.addSubview(activityIndicator)
        self.tableView.addSubview(overlayView)
        self.tableView.bringSubviewToFront(overlayView)
        self.activityIndicator.startAnimating()
    }

}
