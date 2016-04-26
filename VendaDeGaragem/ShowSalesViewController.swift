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
     // Create a reference to a Firebase location
    let myRootRef = Firebase(url:"https://vendadegaragem.firebaseio.com")
    
    var parseConvenience = ParseConvenience()
    var latituteOfLocation = 0.0
    var longitudeOfLocation = 0.0
    
    let dropPin = MKPointAnnotation()
    var annotations = [MKPointAnnotation]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //putSalesOnMap()
        drawFacebbokButtonOnNavItem()
        
        
        
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
    
    func drawFacebbokButtonOnNavItem(){
        let loginFace = FBSDKLoginButton()
        let barButtonFacebook = UIBarButtonItem(customView: loginFace)
        self.navItem.rightBarButtonItem = barButtonFacebook
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
                    print(venda.endereco)
                    
                    let geoCoder = CLGeocoder()
                    let locationString = "\(venda.endereco)"
                    geoCoder.geocodeAddressString(locationString, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                        if error == nil{
                            let alert = UIAlertController(title: ";)", message: "Your location could not be finded! \(venda.endereco)", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            return
                        }else{
                        
                        let placemark = placemarks?[0]
                        let location = placemark?.location
                        let coordinate = location?.coordinate
                        self.latituteOfLocation = coordinate!.latitude
                        self.longitudeOfLocation = coordinate!.longitude
                        self.dropPin.title = "Title"
                        self.dropPin.subtitle = "subtitle"
                        self.dropPin.coordinate = coordinate!
                        var region = MKCoordinateRegion()
                        region.center = coordinate!
                        self.annotations.append(self.dropPin)
                        print(self.annotations)
                        }
                        
                    })
                    
                    print(geoCoder)
                }
            
                
            }
            
           
          
        })
        
        
            self.mapView.addAnnotations(self.annotations)
            print(self.annotations)
        
        

        
        
       
        
    }

}

