//
//  Extensions.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 03/05/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title : String, message : String, preferredSytle : UIAlertControllerStyle) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredSytle)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertErrorFacebook(title : String, message : String, preferredSytle : UIAlertControllerStyle) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredSytle)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}