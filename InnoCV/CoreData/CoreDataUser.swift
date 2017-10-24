//
//  CoreDataUser.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 23/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import Foundation


class CoreDataUser: NSObject {
    
    var id: Int16?
    var name : String?
    var birthdate : String?
    
    override init() {
        super.init()
    }
    
    init(id: Int16?, name: String?, birthdate: String?) {
        
        self.id = id
        self.name = name
        self.birthdate = birthdate
        
    }
    
    
}

