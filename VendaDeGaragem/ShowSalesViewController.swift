//
//  ViewController.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 06/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ShowSalesViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    let buttonFacebook = UIButton()
     // Create a reference to a Firebase location
    let myRootRef = Firebase(url:"https://vendadegaragem.firebaseio.com")
    
    var parseConvenience = ParseConvenience()
    var latituteOfLocation = 0.0
    var longitudeOfLocation = 0.0
    
    let dropPin = MKPointAnnotation()
    var annotations = [MKPointAnnotation]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        
        
        
        // Read data and react to changes
//        myRootRef.observeEventType(.Value, withBlock: {
//            snapshot in
//            print("\(snapshot.key) -> \(snapshot.value)")
//            print(snapshot)
//        })
        
//        let user1 = ["nome" : "hoff silva"]
//        
//        let usersRef = myRootRef.childByAppendingPath("users")
//        
//        let users = ["user1": user1]
//        
//        usersRef.setValue(users)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        putSalesOnMap()
        verifyIfUserIslogged()
    }
    
    
    
    func drawFacebbokButtonOnNavItem(size : Bool){
        buttonFacebook.frame = CGRectMake(0, 0, 0, 0)
        if size == true {
            buttonFacebook.setImage(UIImage(named: "facebookOnline"), forState: .Normal)
            buttonFacebook.addTarget(self, action: #selector(loginButtonClicked), forControlEvents: .TouchDown)
            buttonFacebook.sizeToFit()
            let barButtonFacebook = UIBarButtonItem(customView: buttonFacebook)
            self.navItem.rightBarButtonItem = barButtonFacebook
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
                    self.drawFacebbokButtonOnNavItem(true)
                }
            }
            
        }else{
            
            login.logOut()
            drawFacebbokButtonOnNavItem(false)
        }
        
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

    func putSalesOnMap() {
        
        parseConvenience.gettingVendas({ (networkConectionError) in
            if networkConectionError == true{
                let alert = UIAlertController(title: ":(", message: "Internet conection was lost or server is offline!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                //self.overlayView.removeFromSuperview()
                return
                
            }else{
                
                for venda in VendasSingleton.arrayDeVendas {
                    // print("\(student.firstName) \(student.mapString)")
                    
                    let annotation = MKPointAnnotation()
                    var coordinates = CLLocationCoordinate2D()
                    coordinates.latitude = venda.latitude as CLLocationDegrees
                    coordinates.longitude = venda.longitude as CLLocationDegrees
                    annotation.coordinate = coordinates
                    annotation.title = "\(venda.nome) \(venda.data)"
                    //annotation.subtitle = student.mediaURL
                    // Finally we place the annotation in an array of annotations.
                    self.annotations.append(annotation)

                }
                self.mapView.addAnnotations(self.annotations)
                //self.mapa.setCenterCoordinate(self.mapa.region.center, animated: true)
                //self.overlayView.removeFromSuperview()
            
                
            }
            
           
          
        })
        
        
            self.mapView.addAnnotations(self.annotations)
            print(self.annotations)
        
        

        
        
       
        
    }

}

