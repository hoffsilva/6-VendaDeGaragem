//
//  DetalhVendaTableViewController.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 28/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import MapKit

class DetalhVendaTableViewController: UITableViewController, MKMapViewDelegate {

    var venda : Vendas!
    
    @IBOutlet weak var mapViewLocalDaVenda: MKMapView!
    @IBOutlet weak var labelNomeDaVenda: UILabel!
    @IBOutlet weak var labelDataDaVenda: UILabel!
    @IBOutlet weak var labelHoraInicio: UILabel!
    @IBOutlet weak var labelHoraTermino: UILabel!
    @IBOutlet weak var labelCartao: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        mapViewLocalDaVenda.camera.altitude = 100000
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
        
        if venda.status == "Iniciada"{
            pinView!.image = UIImage(named:"facebookOnline")!
            pinView!.centerOffset = CGPoint(x: -1, y: -12)
        }else if venda.status == "Encerrada"{
            pinView!.image = UIImage(named:"facebookOffline")!
            pinView!.centerOffset = CGPoint(x: -1, y: -12)
        }else{
            print("outro")
        }
        
        return pinView
    }
    
    func vendaAceitaCartao() {
        if venda.forma_pagamento == "sim" {
            labelCartao.text = "Que bom :D! Você poderá pagar com cartão!"
        }else{
            labelCartao.text = "Que pena :/! Aina não aceitamos cartão!"
        }
    }
    
    func statusDaVenda() {
        if venda.status == "Iniciada"{
            labelStatus.text = "Corre! Acho que ainda dá tempo de aproveitar."
        }else if venda.status == "Encerrada"{
            labelStatus.text = "Infelizmente essa venda já foi encerrada ;p!"
        }else{
            labelStatus.text = "Marque no seu calendário! Essa venda está prevista."
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
