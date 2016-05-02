//
//  Vendas.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 22/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import CoreData
@objc(Vendas)

class Vendas: NSManagedObject {
    
    struct Keys {
        static let data = "data"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let forma_pagamento = "forma_pagamento"
        static let hora_inicio = "hora_inicio"
        static let hora_termino = "hora_termino"
        static let nome = "nome"
        static let status = "status"
        static let id_facebook = "id_facebook"
        static let id_azure = "id_azure"
    }
    
    @NSManaged var data : String!
    @NSManaged var latitude: String!
    @NSManaged var longitude: String!
    @NSManaged var forma_pagamento : String!
    @NSManaged var hora_inicio : String!
    @NSManaged var hora_termino : String!
    @NSManaged var nome : String!
    @NSManaged var status : String!
    @NSManaged var id_facebook : String!
    @NSManaged var id_azure : String!
    
    
    
    //var arrayDeVendas = [Vendas]()
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Vendas", inManagedObjectContext: context)!
        
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        data = dictionary[Keys.data] as? String
        latitude = dictionary[Keys.latitude] as? String
        longitude = dictionary[Keys.longitude] as? String
        forma_pagamento = dictionary[Keys.forma_pagamento] as? String
        hora_inicio = dictionary[Keys.hora_inicio] as? String
        hora_termino = dictionary[Keys.hora_termino] as? String
        nome = dictionary[Keys.nome] as? String
        status = dictionary[Keys.status] as? String
        id_facebook = dictionary[Keys.id_facebook] as? String
        id_azure = dictionary[Keys.id_azure] as? String
       
    }

}
