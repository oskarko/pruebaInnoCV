//
//  UserCell.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 23/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userBirthdateLbl: UILabel!
    @IBOutlet weak var userIdLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configCellWithOptions(user: CoreDataUser) {

        if let birthdate = user.birthdate {
            self.userBirthdateLbl.text = "Birthdate: \(birthdate)"
        }
        if let id = user.id {
            self.userIdLbl.text = "ID: \(id)"
        }
        if let name = user.name {
            self.userNameLbl.text = name
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
