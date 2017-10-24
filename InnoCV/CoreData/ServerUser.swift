//
//  ServerUser.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 24/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import Foundation

class ServerUser {
    
    var Id: Int?
    var Name : String
    var Birthdate : String
    
    init(name: String, birthdate: String) {
        
        self.Name = name
        self.Birthdate = birthdate
        
    }
    
    
}
