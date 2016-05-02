//
//  AddSaleTableViewController.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 26/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
//import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import MapKit

class AddSaleTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    var statusVenda = [String]()
    var statusSelected = "iniciada"
    var idOfUser = ""
    let locationManager = CLLocationManager()
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var coordinates = CLLocationCoordinate2D()
    var vendaPersistence = VendaPersistence()
    var venda : Vendas!
    

    
    //let myRootRef = Firebase(url:"https://vendadegaragem.firebaseio.com")
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
        
        if verifyIfIsUpdate(){
            textFieldNome.text = venda.nome!
        }
        
        statusVenda = ["Iniciada", "Prevista", "Encerrada"]
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
//        switch CLLocationManager.authorizationStatus() {
//        case .AuthorizedAlways:
//            coordinates = getCoordinates()
//        // ...
//        case .NotDetermined:
//            locationManager.requestAlwaysAuthorization()
//            
//                 self.coordinates = self.getCoordinates()
//            
//           
//        case .AuthorizedWhenInUse, .Restricted, .Denied:
//            let alertController = UIAlertController(
//                title: "Background Location Access Disabled",
//                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
//                preferredStyle: .Alert)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            
//            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
//                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
//                    UIApplication.sharedApplication().openURL(url)
//                }
//            }
//            alertController.addAction(openAction)
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        getFacebookId()
        locationManagers(locationManager, didChangeAuthorizationStatus: .AuthorizedAlways)
    }
    
    func locationManagers(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .AuthorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .AuthorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .Restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .Denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    
    @IBAction func publicarVenda(sender: AnyObject) {
       
        validateFields()
        
    }
    
    func verifyIfIsUpdate() -> Bool {
        if venda != nil{
            return true
        }else{
            return false
        }
    }
    
    func saveSale() {
    
        print(formataData(datePickerData), String(coordinates.latitude), String(coordinates.longitude),  getCard(),  formataHora(datePickerHoraInicio),  formataHora(datePickerHoraTermino), textFieldNome.text!,  statusSelected ,  idOfUser)
        
        parse.saveVenda(formataData(datePickerData), latitude: String(coordinates.latitude), longitude: String(coordinates.longitude), forma_pagamento: getCard(), hora_inicio: formataHora(datePickerHoraInicio), hora_termino: formataHora(datePickerHoraTermino), nome: textFieldNome.text!, status: statusSelected , id: idOfUser)
        
        vendaPersistence.saveVenda(formataData(datePickerData), latitude: String(coordinates.latitude), longitude: String(coordinates.longitude), forma_pagamento: getCard(), hora_inicio: formataHora(datePickerHoraInicio), hora_termino: formataHora(datePickerHoraTermino), nome: textFieldNome.text!, status: statusSelected, id_facebook: idOfUser, id_azure: "")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateSale() {
        
    }
    
    
    func formataData(data: UIDatePicker) -> String{
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var strDate = dateFormatter.stringFromDate(data.date)
        return strDate
    }
    
    func formataHora(hora: UIDatePicker) -> String {
        var horaFormatter = NSDateFormatter()
        horaFormatter.dateFormat = "HH:mm"
        var strHora = horaFormatter.stringFromDate(hora.date)
        return strHora
    }
    
    
    
    func validateFields() {
        
        var today = NSDate()
        print(today)
        
        if textFieldNome.text == "" {
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.redColor().CGColor
            border.frame = CGRect(x: 0, y: textFieldNome.frame.size.height - width, width:  textFieldNome.frame.size.width, height: textFieldNome.frame.size.height)
            border.borderWidth = width
            textFieldNome.layer.addSublayer(border)
            textFieldNome.layer.masksToBounds = true
            textFieldNome.becomeFirstResponder()
            return
        }else if datePickerHoraInicio.date.compare(datePickerHoraTermino.date) == NSComparisonResult.OrderedDescending || formataHora(datePickerHoraTermino) == formataHora(datePickerHoraInicio){
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.redColor().CGColor
            border.frame = CGRect(x: 0, y: datePickerHoraInicio.frame.size.height - width, width:  datePickerHoraInicio.frame.size.width, height: datePickerHoraInicio.frame.size.height)
            border.borderWidth = width
            datePickerHoraInicio.layer.addSublayer(border)
            datePickerHoraInicio.layer.masksToBounds = true
            
            border.frame = CGRect(x: 0, y: datePickerHoraTermino.frame.size.height - width, width:  datePickerHoraTermino.frame.size.width, height: datePickerHoraTermino.frame.size.height)
            border.borderWidth = width
            datePickerHoraTermino.layer.addSublayer(border)
            datePickerHoraTermino.layer.masksToBounds = true
            datePickerHoraTermino.becomeFirstResponder()
            return
        }else if today.compare(datePickerData.date) == NSComparisonResult.OrderedDescending{
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.redColor().CGColor
            border.frame = CGRect(x: 0, y: datePickerData.frame.size.height - width, width:  datePickerData.frame.size.width, height: datePickerData.frame.size.height)
            border.borderWidth = width
            datePickerData.layer.addSublayer(border)
            datePickerData.layer.masksToBounds = true
            datePickerData.becomeFirstResponder()
            return

        }
        else{
            saveSale()
            
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
