//
//  Vendas.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 22/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit

class Vendas: NSObject {
    
    /*
     data:
     
     forma_pagamento:
     
     hora_inicio:
     
     hora_termino:
     
     id:
     
     latitude:
    
     longitude:
     
     nome:
     
     status: 
     
     
     */
    
    var data : String!
    var latitude: NSNumber!
    var longitude: NSNumber!
    var forma_pagamento : String!
    var hora_inicio : String!
    var hora_termino : String!
    var nome : String!
    var status : String!
    
    var arrayDeVendas = [Vendas]()
    
    init(data : String, latitude: NSNumber, longitude: NSNumber, forma_pagamento : String, hora_inicio: String, hora_termino: String, nome: String, status: String) {
        
        self.data = data
        self.latitude = latitude
        self.longitude = longitude
        self.forma_pagamento = forma_pagamento
        self.hora_inicio = hora_inicio
        self.hora_termino = hora_termino
        self.nome = nome
        self.status = status
    }

}
