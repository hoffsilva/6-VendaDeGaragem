//
//  VendaTableViewCell.swift
//  VendaDeGaragem
//
//  Created by Hoff Henry Pereira da Silva on 27/04/16.
//  Copyright © 2016 hoffsilva. All rights reserved.
//

import UIKit

class VendaTableViewCell: UITableViewCell {

    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var imageStatus: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
