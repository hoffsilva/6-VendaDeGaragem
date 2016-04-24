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
    var endereco : String!
    var forma_pagamento : String!
    var hora_inicio : String!
    var hora_termino : String!
    var nome : String!
    var responsavel : String!
    var status : String!
    
    init(data : String, endereco: String, forma_pagamento : String, hora_inicio: String, hora_termino: String, nome: String, responsavel: String, status: String) {
        
        self.data = data
        self.endereco = endereco
        self.forma_pagamento = forma_pagamento
        self.hora_inicio = hora_inicio
        self.hora_termino = hora_termino
        self.nome = nome
        self.responsavel = responsavel
        self.status = status
    }

}
