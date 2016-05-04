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
    var statusSelected = "Confirmada"
    var idOfUser = ""
    
    var table = UserTableViewController()
    
    
    var overlayView = UIView()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var coordinates = CLLocationCoordinate2D()
    var vendaPersistence = VendaPersistence()
    var venda : Vendas!
    var locationManager: CLLocationManager!
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
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        if verifyIfIsUpdate(){
            textFieldNome.text = venda.nome!
        }
        
        statusVenda = ["Confirmada", "Prevista", "Encerrada"]
        print(coordinates)
    }
    
    override func viewWillAppear(animated: Bool) {
        getFacebookId()
       
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         //coordinates = getCoordinates()
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
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func saveSale() {
        
//        print("\(formataData(datePickerData)) \n")
//        print("\(String(self.locationManager.location!.coordinate.latitude))\n")
//        print("\(String(self.locationManager.location!.coordinate.longitude))\n")
//        print("\(getCard())\n")
//        print("\(formataHora(datePickerHoraInicio))\n")
//        print("\(formataHora(datePickerHoraTermino))\n")
//        print("\(textFieldNome.text!)\n")
//        print("\(statusSelected)\n")
//        print("\(idOfUser)")
        
            var ltd = locationManager.location!.coordinate.latitude
            var lgt = locationManager.location!.coordinate.longitude
        
            print("Longitude: \(ltd)")
            print("Longitude: \(lgt)")
            loadActivityIndicator()
            parse.saveVenda(formataData(datePickerData), latitude: String(self.locationManager.location!.coordinate.latitude), longitude: String(self.locationManager.location!.coordinate.longitude), forma_pagamento: getCard(), hora_inicio: formataHora(datePickerHoraInicio), hora_termino: formataHora(datePickerHoraTermino), nome: textFieldNome.text!, status: statusSelected , id: idOfUser) { (networkConectionError) in
            
            if networkConectionError == true{
                self.overlayView.removeFromSuperview()
                self.showAlert(":(", message: "Internet conection was lost or server is offline!", preferredSytle: UIAlertControllerStyle.Alert)
            }else{
                
                self.vendaPersistence.saveVenda(self.formataData(self.datePickerData), latitude: String(ltd), longitude: String(lgt), forma_pagamento: self.getCard(), hora_inicio: self.formataHora(self.datePickerHoraInicio), hora_termino: self.formataHora(self.datePickerHoraTermino), nome: self.textFieldNome.text!, status: self.statusSelected, id_facebook: self.idOfUser, id_azure: "")
               
                self.parse.gettingVendas({ (networkConectionError) in
                    print("Ok!")
                    self.overlayView.removeFromSuperview()
                    self.table.vendasOfUser(self.idOfUser)
                    self.dismissViewControllerAnimated(true, completion: nil)
                  
                })
                
               
                
                
               
            }
        }
        
    }
    
    func updateSale() {
        loadActivityIndicator()
        var ltd = locationManager.location!.coordinate.latitude
        var lgt = locationManager.location!.coordinate.longitude
        
        print("Longitude: \(ltd)")
        print("Longitude: \(lgt)")
        parse.atualizarVenda(formataData(datePickerData), latitude: String(ltd), longitude: String(lgt), forma_pagamento: getCard(), hora_inicio: formataHora(datePickerHoraInicio), hora_termino: formataHora(datePickerHoraTermino), nome: textFieldNome.text!, status: statusSelected, id_facebook: idOfUser, id_azure: venda.id_azure) { (networkConectionError) in
            if networkConectionError == true{
                self.overlayView.removeFromSuperview()
                self.showAlert(":(", message: "Internet conection was lost or server is offline!", preferredSytle: UIAlertControllerStyle.Alert)
                AddSaleTableViewController().dismissViewControllerAnimated(true, completion: nil)
            }else{
                let objectVenda = self.vendaPersistence.vendaPorIdAzure(self.venda.id_azure)
                let obj = objectVenda[0] as NSManagedObject

                obj.setValue(self.formataData(self.datePickerData), forKey: "data")
                obj.setValue(String(self.coordinates.latitude), forKey: "latitude")
                obj.setValue(String(self.coordinates.longitude), forKey: "longitude")
                obj.setValue(self.getCard(), forKey: "forma_pagamento")
                obj.setValue(self.formataHora(self.datePickerHoraInicio), forKey: "hora_inicio")
                obj.setValue(self.formataHora(self.datePickerHoraTermino), forKey: "hora_termino")
                obj.setValue(self.statusSelected, forKey: "status")
                obj.setValue(self.textFieldNome.text!, forKey: "nome")
                
                do{
                    try obj.managedObjectContext?.save()
                }catch{
                    let saveError = error as NSError
                    print(saveError)
                }
                
                self.parse.gettingVendas({ (networkConectionError) in
                    print("Ok!")
                    self.overlayView.removeFromSuperview()
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                
                //self.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
        
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
            if venda != nil{
                updateSale()
            }else{
                saveSale()
            }
            
            
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
                self.showAlertErrorFacebook("Facebook", message: "Internet conection was lost or server is offline!", preferredSytle: UIAlertControllerStyle.Alert)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
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
    
    func loadActivityIndicator(){
        self.overlayView = UIView(frame: self.tableView.bounds)
        self.overlayView.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 0.5)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.activityIndicator.alpha = 1.0;
        self.activityIndicator.center = self.view.center;
        self.activityIndicator.hidesWhenStopped = true;
        self.overlayView.addSubview(activityIndicator)
        self.tableView.addSubview(overlayView)
        self.tableView.bringSubviewToFront(overlayView)
        self.activityIndicator.startAnimating()
    }

}
