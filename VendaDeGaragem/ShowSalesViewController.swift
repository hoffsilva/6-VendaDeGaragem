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
    
    
  
    @IBOutlet weak var testeItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseConvenience.gettingUsers { (networkConectionError) in
            print(UsersSingleton.arrayOfUsers)
        }
        
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

