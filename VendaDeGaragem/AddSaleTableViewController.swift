//
//  AddSaleTableViewController.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 26/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import MapKit

class AddSaleTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    var statusVenda = [String]()
    var statusSelected = ""
    var idOfUser = ""
    let locationManager = CLLocationManager()
    
    let myRootRef = Firebase(url:"https://vendadegaragem.firebaseio.com")
    let parse = ParseConvenience()

    @IBAction func cancelar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var textFieldNome: UITextField!
    
    @IBOutlet weak var datePickerData: UIDatePicker!
    @IBOutlet weak var datePickerHoraInicio: UIDatePicker!
    @IBOutlet weak var datePickerHoraTermino: UIDatePicker!
    @IBOutlet weak var aceitaCartao: UISwitch!
    @IBOutlet weak var pickerStatus: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        alert("Sua venda deve ter um nome!", titulo: ":\\")
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//            // ...
//        }
//        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.self.presentViewController(alertController, animated: true) {
            // ...
        }
        
        
        
        
        statusVenda = ["Iniciada", "Prevista", "Encerrada"]
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways: break
        // ...
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .AuthorizedWhenInUse, .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        getFacebookId()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    @IBAction func publicarVenda(sender: AnyObject) {
        validateFields()
        let data : String = "\(datePickerData.date)"
        print(data)
        
        alert("", titulo: "")
        parse.saveVenda(data, latitude: "\(getCoordinates().latitude)", longitude: "\(getCoordinates().longitude)", forma_pagamento: "\(getCard())", hora_inicio: "\(datePickerHoraInicio.date)", hora_termino: "\(datePickerHoraTermino.date)", nome: textFieldNome.text!, status: statusSelected, id: "\(idOfUser)")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func manageVenda(data : UIDatePicker, latitude: String, longitude: String, forma_pagamento : String, hora_inicio: UIDatePicker, hora_termino: UIDatePicker, nome: String, status: String, id: String) -> Vendas {
        var venda: Vendas!
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var strDate = dateFormatter.stringFromDate(data.date)
        
        venda.data = strDate
        venda.latitude = latitude
        venda.longitude = longitude
        venda.forma_pagamento = forma_pagamento
        venda.hora_inicio = formataHora(hora_inicio)
        venda.hora_termino = formataHora(hora_termino)
        venda.nome = nome
        venda.id = id

        return venda
    }
    
    func formataHora(hora: UIDatePicker) -> String {
        var horaFormatter = NSDateFormatter()
        horaFormatter.dateFormat = "HH:mm"
        var strHora = horaFormatter.stringFromDate(hora.date)
        return strHora
    }
    
    
    func validateFields() {
        
        if textFieldNome.text == "" {
            alert("Sua venda deve ter um nome!", titulo: ":\\")
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
           self.self.presentViewController(alertController, animated: true) {
                // ...
            }

        }
    }
    
    func alert(msg: String, titulo: String) {
        let alertController = UIAlertController(title: titulo, message: msg, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func getCard() -> String {
        if aceitaCartao.on{
            return "sim"
        }else{
            return "nao"
        }
    }
    
    func getFacebookId() {
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id"], HTTPMethod: "GET")
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                print("result \(result)")
                if let idFacebook = result["id"]{
                    print(idFacebook)
                    self.idOfUser = "\(idFacebook!)"
                }
            }
            else
            {
                print("error \(error)")
            }
        })
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return locationManager.location!.coordinate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusVenda.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusVenda[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusSelected = statusVenda[row]
    }

}
