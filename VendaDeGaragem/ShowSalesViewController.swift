//
//  ViewController.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 06/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import MapKit
//import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class ShowSalesViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    let buttonFacebook = UIButton()
     // Create a reference to a Firebase location
    
    var vendas = [Vendas]()
    
    var vendaPersistence = VendaPersistence()
    var parseConvenience = ParseConvenience()
    var latituteOfLocation = 0.0
    var longitudeOfLocation = 0.0
    
    let dropPin = MKPointAnnotation()
    var annotations = [MKPointAnnotation]()
    var vendaTemp = [Vendas]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
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

    func getVendas(){
        vendas = vendaPersistence.buscarVendas()
    }
    
    func putSalesOnMap() {
        getVendas()
        parseConvenience.gettingVendas({ (networkConectionError) in
            if networkConectionError == true{
                let alert = UIAlertController(title: ":(", message: "Internet conection was lost or server is offline!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                //self.overlayView.removeFromSuperview()
                return
                
            }else{
                print(self.vendas)
                for venda in self.vendas {
                    // print("\(student.firstName) \(student.mapString)")
                    
                    let annotation = MKPointAnnotation()
                    var coordinates = CLLocationCoordinate2D()
                    let lat = Double(venda.latitude)!
                    let long = Double(venda.longitude)!
                    coordinates.latitude = lat as CLLocationDegrees
                    coordinates.longitude = long as CLLocationDegrees
                    annotation.coordinate = coordinates
                    annotation.title = "\(venda.nome!) \(venda.data!)"
                    annotation.subtitle = "\(venda.status)"
                    
                    
                    
                    
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        else {
            pinView!.annotation = annotation
        }
        
        let btn_photoAlbum = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
        let btnImagePhotoAlbum = UIImage(named: "detail")! as UIImage
        btn_photoAlbum.setImage(btnImagePhotoAlbum, forState: .Normal)
        btn_photoAlbum.addTarget(self, action: "detalharVenda", forControlEvents: .TouchUpInside)
        
        pinView!.canShowCallout = true
        if annotation.title! == "Iniciada" {
            pinView!.image = UIImage(named:"facebookOnline")!
        }else if annotation.title! == "Iniciada"{
            pinView!.image = UIImage(named:"detail")!
        }else{
            pinView!.image = UIImage(named:"facebookOffline")!
        }
        
        pinView!.rightCalloutAccessoryView = btn_photoAlbum
        pinView!.centerOffset = CGPoint(x: -1, y: -12)
        
        return pinView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detalharVenda"{
            
            let detalharVenda: DetalhVendaTableViewController = segue.destinationViewController as! DetalhVendaTableViewController
            
            detalharVenda.venda = vendaTemp[0]
        }
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        vendaTemp = vendaPersistence.buscaVendaOfCoodinate((view.annotation?.coordinate)!)
        print(vendaTemp[0])
    }
    
    
    func detalharVenda(){
        self.performSegueWithIdentifier("detalharVenda", sender: self)
    }

}

