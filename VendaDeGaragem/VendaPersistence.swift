//
//  VendaPersistence.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 30/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class VendaPersistence: NSObject, NSFetchedResultsControllerDelegate {
    
    var temporaryContext : NSManagedObjectContext!
    
    var sharedContext: NSManagedObjectContext{
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Vendas")
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    func tryPerformFetch(){
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Nao foi possivel executar o fetchedResultsController.performFetch")
        }
        
        fetchedResultsController.delegate = self
        
        let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
        
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
        
    }
    
    func buscarVendas() -> [Vendas]{
        
        let requsicaoDeBusca = NSFetchRequest(entityName: "Vendas")
        
        do{
            let resultados = try sharedContext.executeFetchRequest(requsicaoDeBusca)
            return resultados as! [Vendas]
            
        }catch let error as NSError{
            print("Não foi possível salvar \(error). \(error.userInfo)")
        }
        
        return []
    }
    
    
    func buscarVendasDeUsuarios(id_facebook: String) -> [Vendas]{
        
        let requsicaoDeBusca = NSFetchRequest(entityName: "Vendas")
        
        print(id_facebook)
        //print(id_facebook)
        
        
        requsicaoDeBusca.predicate = NSPredicate(format: "id_facebook == %@", id_facebook);
        
        do{
            let resultados = try sharedContext.executeFetchRequest(requsicaoDeBusca)
            print(resultados)
            return resultados as! [Vendas]
            
        }catch let error as NSError{
            print("Não foi possível salvar \(error). \(error.userInfo)")
        }
        
        return []
    }
    
        
    func buscaVendaOfCoodinate(coord: CLLocationCoordinate2D) -> [Vendas] {
        
        var lat : NSNumber!
        lat = coord.latitude
        
        var longi : NSNumber!
        longi = coord.longitude
        
        let requsicaoDeBusca = NSFetchRequest(entityName: "Vendas")
        
        requsicaoDeBusca.predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", lat, longi);
        
        do{
            let resultados = try sharedContext.executeFetchRequest(requsicaoDeBusca)
            print(resultados)
            return resultados as! [Vendas]
            
        }catch let error as NSError{
            print("Não foi possível salvar \(error). \(error.userInfo)")
        }
        
        return []
    }
    
    func clearData() {
        let requsicaoDeBusca = NSFetchRequest(entityName: "Vendas")
        let delReq = NSBatchDeleteRequest(fetchRequest: requsicaoDeBusca)
        
        do{
             try sharedContext.executeRequest(delReq)
            print("Dados apagados com sucesso!")
            
        }catch let error as NSError{
            print("Não foi possível apagar os dados!")
        }

    }
    
    
    
    func vendaPorIdAzure(id_azure: String) -> [Vendas] {
        let requsicaoDeBusca = NSFetchRequest(entityName: "Vendas")
        
        requsicaoDeBusca.predicate = NSPredicate(format: "id_azure == %@", id_azure);
        
        do{
            let resultados = try sharedContext.executeFetchRequest(requsicaoDeBusca)
            print(resultados)
            return resultados as! [Vendas]
            
        }catch let error as NSError{
            print("Não foi possível salvar \(error). \(error.userInfo)")
        }
        return []
    }
    
    
    
    func saveVenda(data: String, latitude: String, longitude: String, forma_pagamento: String, hora_inicio: String, hora_termino: String, nome: String, status: String , id_facebook: String, id_azure: String ) -> Vendas {
        //print(coordinate)
        let dictionary: [String : AnyObject] = [
            Vendas.Keys.data : data,
            Vendas.Keys.latitude : latitude,
            Vendas.Keys.longitude : longitude,
            Vendas.Keys.forma_pagamento : forma_pagamento,
            Vendas.Keys.hora_inicio : hora_inicio,
            Vendas.Keys.hora_termino : hora_termino,
            Vendas.Keys.nome : nome,
            Vendas.Keys.status : status,
            Vendas.Keys.id_facebook : id_facebook,
            Vendas.Keys.id_azure : id_azure
        ]
        //print(dictionary)
        let newVenda = Vendas(dictionary: dictionary, context: sharedContext)
        print(newVenda)
        CoreDataStackManager.sharedInstance().saveContext()
        return newVenda
    }
    

}
