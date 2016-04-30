//
//  Vendas.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 22/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit

class Vendas: NSObject {
    
    var data : String!
    var latitude: String!
    var longitude: String!
    var forma_pagamento : String!
    var hora_inicio : String!
    var hora_termino : String!
    var nome : String!
    var status : String!
    var id : String!
    
    var arrayDeVendas = [Vendas]()
    
    init(data : String, latitude: String, longitude: String, forma_pagamento : String, hora_inicio: String, hora_termino: String, nome: String, status: String, id: String) {
        
        self.data = data
        self.latitude = latitude
        self.longitude = longitude
        self.forma_pagamento = forma_pagamento
        self.hora_inicio = hora_inicio
        self.hora_termino = hora_termino
        self.nome = nome
        self.status = status
        self.id = id
    }

}
