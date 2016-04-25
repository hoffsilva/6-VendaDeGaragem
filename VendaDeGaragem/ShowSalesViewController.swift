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

    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
     // Create a reference to a Firebase location
    let myRootRef = Firebase(url:"https://vendadegaragem.firebaseio.com")
    
    var parseConvenience = ParseConvenience()
    var latituteOfLocation = 0.0
    var longitudeOfLocation = 0.0
    
    let dropPin = MKPointAnnotation()

  
    @IBOutlet weak var testeItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseConvenience.gettingVendas({ (networkConectionError) in
            if networkConectionError == true{
                let alert = UIAlertController(title: ":(", message: "Internet conection was lost or server is offline!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                //self.overlayView.removeFromSuperview()
                return
                
            }else{
               // var i = 0
                for venda in VendasSingleton.arrayDeVendas {
                    // print("\(student.firstName) \(student.mapString)")
                    print(venda.endereco)
                    
                    let geoCoder = CLGeocoder()
                    let locationString = "\(venda.endereco)"
                    geoCoder.geocodeAddressString(locationString, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                        guard error == nil else{
                            let alert = UIAlertController(title: ";)", message: "Your location could not be finded!", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            //self.activityIndicator.hidden = true
                            return
                        }
                        // self.studentLocationExists()
                       // if placemarks?.count > 0 {
                            let placemark = placemarks?[0]
                            let location = placemark?.location
                            let coordinate = location?.coordinate
                            //  print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                            self.latituteOfLocation = coordinate!.latitude
                            self.longitudeOfLocation = coordinate!.longitude
                            
                            self.dropPin.title = "Title"
                            self.dropPin.subtitle = "subtitle"
                            self.dropPin.coordinate = coordinate!
                            print(coordinate!)
                            var region = MKCoordinateRegion()
                            region.center = coordinate!
                            self.mapView.addAnnotation(self.dropPin)
                            //self.textField_Location.hidden = true
                            //self.textField_Link.hidden = false
                            //self.mapView_LocationFinded.hidden = false
                            //self.buttonFindOnTheMap.hidden = true
                            //self.button_Submit.hidden = false
                            //self.mapView.setRegion(region, animated: true)
                            //self.activityIndicator.hidden = true
                        //}
                    })
                    
                    self.mapView.reloadInputViews()
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = student.coordinate
//                    annotation.title = "\(student.firstName) \(student.lastName)"
//                    annotation.subtitle = student.mediaURL
//                    // Finally we place the annotation in an array of annotations.
//                    annotations.append(annotation)
                    //i = i+1
                }
                
                // When the array is complete, we add the annotations to the map.
//                self.mapa.addAnnotations(annotations)
//                self.mapa.setCenterCoordinate(self.mapa.region.center, animated: true)
//                self.overlayView.removeFromSuperview()
            }
                print(VendasSingleton.arrayDeVendas)
        })
        
        
        let loginFace = FBSDKLoginButton()
        
        let barButton = UIBarButtonItem(customView: loginFace)
        
        self.testeItem.rightBarButtonItem = barButton
        
        
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

    @IBAction func enviar(sender: AnyObject) {
        
//        let gs1 = ["nome": "Venda de utensilios domesticos1", "data": "June 23, 1912", "endereco": "SHIS QI 23, Conjunto 6, Casa 19. Lago Sul", "hora_inicio":"09:00", "hora_termino":"16:00",  "forma_pagamento":"Cartao de credito/debito, dinheiro",  "responsavel":"Fulano da Silva",  "status":"confirmada/iniciada/encerrada" ]
//        
//        let gs2 = ["nome": "Venda de utensilios domesticos2", "data": "June 30, 1912", "endereco": "SHIS QI 23, Conjunto 6, Casa 19. Lago Sul", "hora_inicio":"09:00", "hora_termino":"16:00",  "forma_pagamento":"Cartao de credito/debito, dinheiro",  "responsavel":"Fulano da Silva",  "status":"confirmada/iniciada/encerrada" ]
//        
//        let gs3 = ["nome": "Venda de utensilios domesticos3", "data": "June 07, 1912", "endereco": "SHIS QI 23, Conjunto 6, Casa 19. Lago Sul", "hora_inicio":"09:00", "hora_termino":"16:00",  "forma_pagamento":"Cartao de credito/debito, dinheiro",  "responsavel":"Fulano da Silva",  "status":"confirmada/iniciada/encerrada" ]
//        
//        let vendasRef = myRootRef.childByAppendingPath("users/user1/vendas")
//        
//        let vendas = ["venda1" : gs1, "venda2" : gs2, "venda3" : gs3 ]
//        
//        // Write data to Firebase
//        vendasRef.setValue(vendas)
   
//        myRootRef.updateChildValues([
//            "users/user1/vendas/venda3/status": "\(campoDeTexto.text!)",
//            ])
        
        
        //myRootRef.setValue()
        //campoDeTexto.text = ""
        
        
    }

}

