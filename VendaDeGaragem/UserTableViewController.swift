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
    var vendasOfUser = [Vendas]
    
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VendasSingletonOfUser.arrayDeVendasDoUsuario.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("vendaCell", forIndexPath: indexPath) as! VendaTableViewCell
        
        cell.labelNome.text = "\(VendasSingletonOfUser.arrayDeVendasDoUsuario[indexPath.row].nome)"
        cell.labelData.text = "\(VendasSingletonOfUser.arrayDeVendasDoUsuario[indexPath.row].data)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        actionDetailVenda()
//        if let toOpen = studentsModel[indexPath.row].mediaURL {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        app.openURL(NSURL(string: "\(StudentsSingleton.arrayOfStudents[indexPath.row].mediaURL)")!)
//         }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
            self.navItem.title = "Minhas Vendas"
            addButton()
        }else{
            buttonFacebook.setImage(UIImage(named: "facebookOffline"), forState: .Normal)
            buttonFacebook.addTarget(self, action: #selector(loginButtonClicked), forControlEvents: .TouchDown)
            buttonFacebook.sizeToFit()
            let barButtonFacebook = UIBarButtonItem(customView: buttonFacebook)
            self.navItem.rightBarButtonItem = barButtonFacebook
            self.navItem.title = "Efetue Login"
            VendasSingletonOfUser.arrayDeVendasDoUsuario.removeAll()
            reloadTableView()
        }
    }
    
    func vendasOfUser(id: String){
        vendaPersistence.buscarVendasDeUsuarios(idOfFacebook)
        
        VendasSingletonOfUser.arrayDeVendasDoUsuario.removeAll()
        for venda in VendasSingleton.arrayDeVendas {
            var idOfVenda = ""
            idOfVenda = "\(venda.id_facebook)"
            if idOfVenda == id{
                print("deu certo!!")
                
                //VendasSingletonOfUser.arrayDeVendasDoUsuario.append(Vendas(data: venda.data, latitude: venda.latitude, longitude: venda.longitude, forma_pagamento: venda.forma_pagamento, hora_inicio: venda.hora_inicio, hora_termino: venda.hora_termino, nome: venda.nome, status: venda.status, id: venda.id))
            }
        }
        
       reloadTableView()
        
    }
    
    
    func actionDetailVenda(){
        self.performSegueWithIdentifier("detalhaVenda", sender: view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detalhaVenda"{
            let indexPaths = tableView.indexPathForSelectedRow
            //let indexPath = indexPaths![0] as! NSIndexPath
            let detalhaVenda : DetalhVendaTableViewController = segue.destinationViewController as! DetalhVendaTableViewController
            print(VendasSingletonOfUser.arrayDeVendasDoUsuario[(indexPaths?.row)!])
            detalhaVenda.venda = VendasSingletonOfUser.arrayDeVendasDoUsuario[(indexPaths?.row)!]
//            print(photos[indexPath.row])
            print("Detalhou!")
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
                                self.vendasOfUser = self.vendaPersistence.buscarVendasDeUsuarios("\(idFacebook!)")
                                //var teste = "\(idFacebook!)"
                                //self.vendasOfUser(teste)
                            }
                        }
                        else
                        {
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
                    print("error \(error)")
                }
            })
            
            drawFacebbokButtonOnNavItem(true)
        }

    }
    
    

}
