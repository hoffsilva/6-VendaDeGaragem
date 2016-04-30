//
//  ParseConvenience.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 22/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit


class ParseConvenience: NSObject {
    
    
    func saveVenda(data : String, latitude: String, longitude: String, forma_pagamento : String, hora_inicio: String, hora_termino: String, nome: String, status: String, id: String) {
        let client = MSClient(
            applicationURLString:"https://hoff.azure-mobile.net/",
            applicationKey:"fuTRPteGDvNoNASjLJwTrcasxSNQZE27"
        )
        let table = client.tableWithName("Venda")
        
    
        
        var itemToInsert:NSDictionary = ["data":data,
                                         "forma_pagamento": forma_pagamento,
                                         "hora_inicio": hora_inicio,
                                         "hora_termino": hora_termino,
                                         "id_facebook": id,
                                         "latitude": latitude,
                                         "longitude": longitude,
                                         "nome": nome,
                                         "status": status]
        
        table.insert(itemToInsert as [NSObject : AnyObject],
                         completion: {
                            insertedItem, error in
                            if (error != nil){
                                print("error: \(error)")
                            }
                            else{
                                print("Success!")
                            }
            }
        )
        
        
        //client.syncTableWithName("Venda")
    }
    
    func gettingVendas(onCompletion: (networkConectionError : Bool) ->()){
       // curl "https://vendadegaragem.firebaseio.com/users.json"
        let request = NSMutableURLRequest(URL: NSURL(string: "https://vendadegaragem.firebaseio.com/users/user1.json")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil { // Handle error...
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    print(parsedResult)
                    } catch {
                    parsedResult = nil
                    return
                }
                
                
                if let arrayOfVendas = parsedResult["vendas"] as? [String:AnyObject]{
                        var i=1
                    VendasSingleton.arrayDeVendas.removeAll()
                        for vendas in arrayOfVendas{
                            //var venda = String(format: "venda%d", i)
                            if let vendaCurrent = vendas.1 as? [String:AnyObject]{
                                VendasSingleton.arrayDeVendas.append(
                                    Vendas(data: (vendaCurrent["data"] as? String)!,
                                    latitude: (vendaCurrent["latitude"] as? String)!,
                                    longitude: (vendaCurrent["longitude"] as? String)!,
                                    forma_pagamento: (vendaCurrent["forma_pagamento"] as? String)!,
                                    hora_inicio: (vendaCurrent["hora_inicio"] as? String)!,
                                    hora_termino: (vendaCurrent["hora_termino"] as? String)!,
                                    nome: (vendaCurrent["nome"] as? String)!,
                                    status: (vendaCurrent["status"] as? String)!,
                                    id: (vendaCurrent["id"] as? String)!))
                                i = i+1
                            }
                            
                        }
                    }
 
                    

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        onCompletion(networkConectionError: false)
                    })

            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onCompletion(networkConectionError: true)
                })
            }
            
            
            
            
            
        }
        task.resume()
    }
    
    func getVendas(onCompletion: (networkConectionError : Bool) ->()){
        // curl "https://vendadegaragem.firebaseio.com/users.json"
        let request = NSMutableURLRequest(URL: NSURL(string: "https://vendadegaragem.firebaseio.com/vendas.json")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil { // Handle error...
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    print(parsedResult)
                } catch {
                    parsedResult = nil
                    return
                }
                
                
                if let arrayOfVendas = parsedResult["vendas"] as? [String:AnyObject]{
                    var i=1
                    
                    for vendas in arrayOfVendas{
                       // var venda = String(format: "venda%d", i)
                        if let vendaCurrent = vendas.1 as? [String:AnyObject]{
                            VendasSingleton.arrayDeVendas.append(
                                Vendas(data: (vendaCurrent["data"] as? String)!,
                                    latitude: (vendaCurrent["latitude"] as? String)!,
                                    longitude: (vendaCurrent["longitude"] as? String)!,
                                    forma_pagamento: (vendaCurrent["forma_pagamento"] as? String)!,
                                    hora_inicio: (vendaCurrent["hora_inicio"] as? String)!,
                                    hora_termino: (vendaCurrent["hora_termino"] as? String)!,
                                    nome: (vendaCurrent["nome"] as? String)!,
                                    status: (vendaCurrent["status"] as? String)!,
                                    id: (vendaCurrent["id"] as? String)!))
                            i = i+1
                        }
                        
                    }
                }
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onCompletion(networkConectionError: false)
                })
                
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onCompletion(networkConectionError: true)
                })
            }
            
            
            
            
            
        }
        task.resume()
    }


}
