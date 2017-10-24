//
//  UserService.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 23/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserService {
    
    static let shared = UserService()
    
    
    //let server: String = "http://serverproInnoCV/api"   // PRO
    let server: String = "http://hello-world.innocv.com/api" // DEV
    
    
    
    
    
    func getAllUsers(completionHandler: @escaping ([String:String]?) -> Void) {
        
        
        let url = URL(string: "\(server)/user/getall")!
       
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: nil).validate(statusCode: 200..<600).responseJSON() { response in
                            
                            switch response.result {
                            case .success:
                                
                                var result = [String:String]()
                                
                                if let value = response.result.value {
                                    
                                    let json = JSON(value)
                                    let allUsers = json.array
                                    
                                    if let allUsers = allUsers {
                                        for user in allUsers {
                                            
                                            if (LocalCoreDataUserService.shared.getUser(id: user["id"].int16Value) == nil) { // is in CoreDate yet?
                                                let coreDataUser = CoreDataUser()
                                                coreDataUser.id = user["id"].int16Value
                                                coreDataUser.name = user["name"].stringValue
                                                coreDataUser.birthdate = user["birthdate"].stringValue
                                                
                                                LocalCoreDataUserService.shared.insertCoreDataUser(coreDataUser: coreDataUser)
                                            }
                                        }
                                        
                                        result["status"] = "ok"
                                    }
                                    else {
                                        result["status"] = "error"
                                    }
                                }
                                
                                completionHandler(result)
                            case .failure(let error):
                                print("error getting all user: \(error)")
                                completionHandler(nil)
                            }
                            
        }
        
    }
    
    
    
    
    
    // create user
    func createUser(user: CoreDataUser, completionHandler: @escaping ([String:String]?) -> Void) {
        
        let url = URL(string: "\(server)/user/create")!
        var params : [String : String] = [:]
        
        params["name"] = user.name!
        params["birthdate"] = user.birthdate!
        print("params: \(params["name"]) \(params["birthdate"])")
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<600).responseJSON() { response in
            
            print("create response: \(response)")
            switch response.result {
            case .success:
                
                var result = [String:String]()
                
                
                if let value = response.result.value {
                    
                    let json = JSON(value) // parseamos el JSON con SwiftJson
                    
                    let messageExist = json["message"].exists()
                    
                    if (messageExist) {
                        
                        result = ["status": "error"]
                    }
                    else {
                        let coreDataUser = CoreDataUser()
                        coreDataUser.id = json["id"].int16Value
                        coreDataUser.name = json["name"].stringValue
                        coreDataUser.birthdate = json["birthdate"].stringValue
                        
                        LocalCoreDataUserService.shared.insertCoreDataUser(coreDataUser: coreDataUser)
                    }
                    
                    
                }

                completionHandler(result)
            case .failure(let error):
                print("error creating new user: \(error)")
                completionHandler(nil)
            }
            
        }
        
    }
    
    
    
    
    
    // update user
    func updateUser(user: CoreDataUser, completionHandler: @escaping ([String:String]?) -> Void) {
        
        let url = URL(string: "\(server)/user/update")!
        var params : [String : String] = [:]
        
        params["id"] = "\(user.id!)"
        params["name"] = user.name!
        params["birthdate"] = user.birthdate!

        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<600).responseJSON() { response in
            
            print("create response: \(response)")
            switch response.result {
            case .success:
                
                var result = [String:String]()
                
                
                if let value = response.result.value {
                    
                    let json = JSON(value) // parseamos el JSON con SwiftJson
                    
                    let messageExist = json["message"].exists()
                    
                    if (messageExist) {
                        
                        result = ["status": "error"]
                    }
                    else {
                        let coreDataUser = LocalCoreDataUserService.shared.getUser(id: json["id"].int16Value)
                        
                        if let coreDataUser = coreDataUser {
                            coreDataUser.name = json["name"].stringValue
                            coreDataUser.birthdate = json["birthdate"].stringValue
                        
                            LocalCoreDataUserService.shared.updateCoreDataUser(coreDataUser: coreDataUser)
                            result = ["status": "ok"]
                        }
                    }
                    
                    
                }
                
                completionHandler(result)
            case .failure(let error):
                print("error creating new user: \(error)")
                completionHandler(nil)
            }
            
        }
        
    }
    
    
    
    
    // delete user
    func deleteUser(id: Int16, completionHandler: @escaping ([String:String]?) -> Void) {
        
        let url = URL(string: "\(server)/user/remove")!
        var params : [String : String] = [:]
        
        params["id"] = "\(id)"

        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<600).responseJSON() { response in
            
            if response.error != nil {
                // bad delete
                completionHandler(nil)
            }
            else {
                LocalCoreDataUserService.shared.deleteUser(id: id)
                completionHandler(["status": "ok"])
            }
            
        }
        
    }



    
    
    
    
    

}
