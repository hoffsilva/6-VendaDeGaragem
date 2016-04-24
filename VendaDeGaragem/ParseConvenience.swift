//
//  ParseConvenience.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 22/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit

class ParseConvenience: NSObject {
    
   static func gettingUsers(onCompletion: (networkConectionError : Bool) ->()){
       // curl "https://vendadegaragem.firebaseio.com/users.json"
        let request = NSMutableURLRequest(URL: NSURL(string: "https://vendadegaragem.firebaseio.com/users.json")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil { // Handle error...
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                } catch {
                    parsedResult = nil
                    return
                }
                
                if let arrayOfResults = parsedResult["users"] as?[[String:AnyObject]]{
                    //StudentsSingleton.arrayOfStudents.removeAll()
                     var arrayDeVendas = Array<Vendas>()
                    
                    if let arrayOfVendas = parsedResult["vendas"] as? [[String:AnyObject]]{
                       
                        for vendas in arrayOfVendas{
                            let venda = Vendas(data: (vendas["data"] as? String)!, endereco: (vendas["endereco"] as? String)!, forma_pagamento: (vendas["forma_pagamento"] as? String)!, hora_inicio: (vendas["hora_inicio"] as? String)!, hora_termino: (vendas["hora_termino"] as? String)!, nome: (vendas["nome"] as? String)!, responsavel: (vendas["responsavel"] as! String), status: (vendas["status"] as? String)!)
                            arrayDeVendas.append(venda)
                        }
                    }
                    
                    for user in arrayOfResults{
                        UsersSingleton.arrayOfUsers.append(UserModel(nome: user["nome"] as! String, vendas: arrayDeVendas))
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        onCompletion(networkConectionError: false)
                    })
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        onCompletion(networkConectionError: true)
                    })
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onCompletion(networkConectionError: true)
                })
            }
            
            
            
            
            
        }
        task.resume()
    }


}
