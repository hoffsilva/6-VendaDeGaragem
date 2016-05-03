//
//  DetalhVendaTableViewController.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 28/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import MapKit

import FBSDKLoginKit
import FBSDKCoreKit

class DetalhVendaTableViewController: UITableViewController, MKMapViewDelegate {

    var venda : Vendas!
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var mapViewLocalDaVenda: MKMapView!
    @IBOutlet weak var labelNomeDaVenda: UILabel!
    @IBOutlet weak var labelDataDaVenda: UILabel!
    @IBOutlet weak var labelHoraInicio: UILabel!
    @IBOutlet weak var labelHoraTermino: UILabel!
    @IBOutlet weak var labelCartao: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var editarButton: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // navigationItem.title = "sdada"
        //asasa.title = "\(venda.nome!)"
        
        addPinOnMap()
        vendaAceitaCartao()
        statusDaVenda()
        labelHoraInicio.text = venda.hora_inicio!
        labelHoraTermino.text = venda.hora_termino!
        labelNomeDaVenda.text = venda.nome!
        labelDataDaVenda.text = venda.data!
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        verifyIfUserIslogged()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    func addPinOnMap() {
        let annotation = MKPointAnnotation()
        var coordinates = CLLocationCoordinate2D()
        let lat = Double(venda.latitude)!
        let long = Double(venda.longitude)!
        coordinates.latitude = lat as CLLocationDegrees
        coordinates.longitude = long as CLLocationDegrees
        annotation.coordinate = coordinates
        var region = MKCoordinateRegion()
        region.center = annotation.coordinate
        mapViewLocalDaVenda.setRegion(region, animated: true)
        mapViewLocalDaVenda.camera.altitude = 500
        mapViewLocalDaVenda.setCenterCoordinate(mapViewLocalDaVenda.region.center, animated: true)
        mapViewLocalDaVenda.addAnnotation(annotation)
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
        
        if venda.status == "Confirmada"{
            pinView!.image = UIImage(named:"confirmada")!
            pinView!.centerOffset = CGPoint(x: -1, y: -12)
        }else if venda.status == "Encerrada"{
            pinView!.image = UIImage(named:"encerrada")!
            pinView!.centerOffset = CGPoint(x: -1, y: -12)
        }else{
            pinView!.image = UIImage(named:"prevista")!
            pinView!.centerOffset = CGPoint(x: -1, y: -12)
        }
        
        return pinView
    }
    
    func vendaAceitaCartao() {
        if venda.forma_pagamento == "sim" {
            labelCartao.text = "Que bom :D! \nVocê poderá pagar com cartão!"
        }else{
            labelCartao.text = "Que pena :/! \nNão aceitamos cartão!"
        }
    }
    
    @IBAction func closeDetail(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func statusDaVenda() {
        if venda.status == "Confirmada"{
            labelStatus.text = "Corre! \nAinda dá tempo de aproveitar."
        }else if venda.status == "Encerrada"{
            labelStatus.text = "Infelizmente essa venda já foi encerrada ;p!"
        }else{
            labelStatus.text = "Marque no seu calendário! \nEssa venda está prevista."
        }
    }
    
    func verifyIfUserIslogged(){
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            editButton(false)
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
                        if (idFacebook as? String)! == self.venda.id_facebook{
                            self.editButton(true)
                        }else{
                            self.editButton(false)
                        }
                    }
                }
                else
                {
                    print("error \(error)")
                    self.showAlert("Facebook", message: "Internet conection was lost or server is offline!", preferredSytle: UIAlertControllerStyle.Alert)
                }
            })
            
            //editButton(true)
        }
        
    }
    
    
    func editButton(active: Bool) {
        if active {
            editarButton.enabled = true
        }else{
            editarButton.enabled = false
        }
    }

    @IBAction func editarButtonAction(sender: AnyObject) {
        performSegueWithIdentifier("editarVenda", sender: view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editarVenda"{
            let editarVenda : AddSaleTableViewController = segue.destinationViewController as! AddSaleTableViewController
            editarVenda.venda = venda
            print("Detalhou: \(venda)")
        }
    }

}
