//
//  UserModel.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 22/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    init(nome : String, vendas : Array<Vendas>) {
        
        self.nome = nome
        self.vendas = vendas
        
    }
    
    var nome : String?
    var vendas : [Vendas]
    var arrayOfUsers = [UserModel]()

}
