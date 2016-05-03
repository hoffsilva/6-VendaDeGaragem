//
//  ParseConvenience.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 22/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit


class ParseConvenience: NSObject {
    
    let client = MSClient(
        applicationURLString: Constants.BASE_URL,
        applicationKey: Constants.API_KEY
    )
    
    var vendaPersistence = VendaPersistence()
    
    func saveVenda(data : String, latitude: String, longitude: String, forma_pagamento : String, hora_inicio: String, hora_termino: String, nome: String, status: String, id: String, onCompletion: (networkConectionError : Bool) ->() )  {
        
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
                                dispatch_async(dispatch_get_main_queue(), { 
                                    onCompletion(networkConectionError: true)
                                })
                                print("error: \(error)")
                            }
                            else{
                                dispatch_async(dispatch_get_main_queue(), {
                                    onCompletion(networkConectionError: false)
                                })
                                print("Success!")
                            }
            }
        )
        
    }
    
    func deletarVenda(id_azure: String, onCompletion: (networkConectionError : Bool) -> ()) {
        let table = client.tableWithName("Venda")
        table.deleteWithId(id_azure) { (result, error) in
            if (error != nil){
                dispatch_async(dispatch_get_main_queue(), {
                    onCompletion(networkConectionError: true)
                })
                print("error: \(error)")
            }
            else{
                dispatch_async(dispatch_get_main_queue(), {
                    onCompletion(networkConectionError: false)
                })
                print("Success!")
            }
        }
    }
    
    func atualizarVenda(data : String, latitude: String, longitude: String, forma_pagamento : String, hora_inicio: String, hora_termino: String, nome: String, status: String, id_facebook: String, id_azure: String, onCompletion: (networkConectionError : Bool) ->() ) {
        let table = client.tableWithName("Venda")
        var oldItem:NSDictionary = ["data":data,
                                         "forma_pagamento": forma_pagamento,
                                         "hora_inicio": hora_inicio,
                                         "hora_termino": hora_termino,
                                         "id_facebook": id_facebook,
                                         "latitude": latitude,
                                         "longitude": longitude,
                                         "nome": nome,
                                         "status": status]
        
        var newItem = oldItem.mutableCopy() as! NSDictionary; // oldItem is NSDictionary
        newItem.setValue(id_azure, forKey: "id")
        newItem.setValue(data, forKey: "data")
        newItem.setValue(forma_pagamento, forKey: "forma_pagamento")
        newItem.setValue(hora_inicio, forKey: "hora_inicio")
        newItem.setValue(hora_termino, forKey: "hora_termino")
        newItem.setValue(id_facebook, forKey: "id_facebook")
        newItem.setValue(latitude, forKey: "latitude")
        newItem.setValue(longitude, forKey: "longitude")
        newItem.setValue(nome, forKey: "nome")
        newItem.setValue(status, forKey: "status")
        
        table.update(newItem as [NSObject : AnyObject]) { (result, error) in
            if (error != nil){
                dispatch_async(dispatch_get_main_queue(), {
                    onCompletion(networkConectionError: true)
                })
                print("error: \(error)")
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    onCompletion(networkConectionError: false)
                })
                print("Success!")
            }
        }

    }
    
    func gettingVendas(onCompletion: (networkConectionError : Bool) ->()){
        let table = client.tableWithName("Venda")
        
        table.readWithCompletion { (result, error) in
            if let error = error{
                print(error)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onCompletion(networkConectionError: true)
                })
                return
            }else if let itens = result.items{
                self.vendaPersistence.clearData()
                if itens.count > 0{
                    print(itens)
                    
                    for venda in itens{
                        self.vendaPersistence.saveVenda(venda["data"] as! String, latitude: venda["latitude"] as! String, longitude: venda["longitude"] as! String, forma_pagamento: venda["forma_pagamento"] as! String, hora_inicio: venda["hora_inicio"] as! String, hora_termino: venda["hora_termino"] as! String, nome: venda["nome"] as! String, status: venda["status"] as! String, id_facebook: venda["id_facebook"] as! String, id_azure: venda["id"] as! String)
                   // print(VendasSingleton.arrayDeVendas)
                    }
                    CoreDataStackManager.sharedInstance().saveContext()
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
    }
    
    


}
