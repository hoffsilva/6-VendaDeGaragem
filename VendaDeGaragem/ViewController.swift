//
//  ViewController.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 06/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var campoDeTexto: UITextField!
    @IBOutlet weak var botaoEnviar: UIButton!
    let myRootRef = Firebase(url:"https://vendadegaragem.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create a reference to a Firebase location
       
        // Write data to Firebase
       // myRootRef.setValue("Do you have data? You'll love Firebase.")
        
        // Read data and react to changes
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
            print(snapshot)
        })
        
        
        /*
        
        Venda:
        EnviarLocalização
        A localização será definida pelo endereço do que o usuário cadastrar ou, se ele permitir, pela localização do aparelho.
        EnviarEndereço
        Definição do endereço da venda.
        EnviarTitulo
        
        EnviarMaior Preco
        EnviarMenor Preco
        EnviarData
        EnviarHorario de Inicio e fim.
        EnviarForma de pagamento
        As formas de pagamento serão: Cartao de debito, Crédito, Dinheiro ou cheque, será definido pelo vendedor.
        EnviarResponsável
        Nome do responsável pela venda.
        EnviarQuantidade de Produtos
        EnviarPreço total dos Produtos
        EnviarPreço total de produtos vendidos
        EnviarStatus - Encerrada- Icone Cinza, Iniciada - Icone Amarelo, Não iniciada - Icone Verde
        EnviarCada venda terá um annotationview com o Titulo e um ícone para detalhar.
        
        
        
        */
        
//        let user1 = ["nome" : "hoff silva"]
//        
//        let usersRef = myRootRef.childByAppendingPath("users")
//        
//        let users = ["user1": user1]
//        
//        usersRef.setValue(users)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enviar(sender: AnyObject) {
        
        let gs1 = ["nome": "Venda de utensilios domesticos1", "data": "June 23, 1912", "endereco": "SHIS QI 23, Conjunto 6, Casa 19. Lago Sul", "hora_inicio":"09:00", "hora_termino":"16:00",  "forma_pagamento":"Cartao de credito/debito, dinheiro",  "responsavel":"Fulano da Silva",  "status":"confirmada/iniciada/encerrada" ]
        
        let gs2 = ["nome": "Venda de utensilios domesticos2", "data": "June 30, 1912", "endereco": "SHIS QI 23, Conjunto 6, Casa 19. Lago Sul", "hora_inicio":"09:00", "hora_termino":"16:00",  "forma_pagamento":"Cartao de credito/debito, dinheiro",  "responsavel":"Fulano da Silva",  "status":"confirmada/iniciada/encerrada" ]
        
        let gs3 = ["nome": "Venda de utensilios domesticos3", "data": "June 07, 1912", "endereco": "SHIS QI 23, Conjunto 6, Casa 19. Lago Sul", "hora_inicio":"09:00", "hora_termino":"16:00",  "forma_pagamento":"Cartao de credito/debito, dinheiro",  "responsavel":"Fulano da Silva",  "status":"confirmada/iniciada/encerrada" ]
        
        let vendasRef = myRootRef.childByAppendingPath("users/user1/vendas")
        
        let vendas = ["venda1" : gs1, "venda2" : gs2, "venda3" : gs3 ]
        
        vendasRef.setValue(vendas)
   
        myRootRef.updateChildValues([
            "users/user1/vendas/venda3/status": "\(campoDeTexto.text!)",
            ])
        
        
        //myRootRef.setValue()
        //campoDeTexto.text = ""
        
    }

}

