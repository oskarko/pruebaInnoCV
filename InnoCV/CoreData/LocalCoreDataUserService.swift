//
//  LocalCoreDataUserService.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 23/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import Foundation
import CoreData


class LocalCoreDataUserService {
    
    static let shared = LocalCoreDataUserService()
    
    let stack  = CoreDataStack.sharedInstance
    
    
    
    
    func insertCoreDataUser(id: Int16, name: String?, birthdate: String?) {
       
        var coreDataUser: User
        var context: NSManagedObjectContext
        
        
        if #available(iOS 10.0, *) {
            context = stack.persistentContainer.viewContext
            coreDataUser = User(context: context)
        } else {
            // Fallback on earlier versions
            context = stack.managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
            coreDataUser = User(entity: entity, insertInto: context)
        }
        
        coreDataUser.id = Int16(id)

        if let name = name {
            coreDataUser.name = name
        }
        if let birthdate = birthdate {
            coreDataUser.birthdate = Utils.fromStringToDate(date: birthdate) as NSDate
        }
        
        do {
            try context.save()
            print("Entry to User saved correctly -> [id: \(id), name: \(name ?? ""), birthDate: \(birthdate ?? "")]")
        } catch {
            print("Error while inserting Core Data")
        }
        
    }
    
    
    
    func insertCoreDataUser(coreDataUser: CoreDataUser) {
        
        var user: User
        var context: NSManagedObjectContext
        
        
        if #available(iOS 10.0, *) {
            context = stack.persistentContainer.viewContext
            user = User(context: context)
        } else {
            // Fallback on earlier versions
            context = stack.managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
            user = User(entity: entity, insertInto: context)
        }
        
        user.id = Int16(coreDataUser.id!)
        user.name = coreDataUser.name
        user.birthdate = Utils.fromStringToDate(date: coreDataUser.birthdate!) as NSDate
        
        
        do {
            try context.save()
            print("Entry to User saved correctly -> [id: \(coreDataUser.id ?? 0), name: \(coreDataUser.name ?? ""), birthDate: \(coreDataUser.birthdate ?? "")]")
        } catch {
            print("Error while inserting Core Data")
        }
        
    }
    
    
    
    func updateCoreDataUser(coreDataUser: CoreDataUser) {
        
        var context: NSManagedObjectContext
        
        if #available(iOS 10.0, *) {
            context = stack.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            context = stack.managedObjectContext
        }
        let request : NSFetchRequest<User> = User.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "id = %@", "\(coreDataUser.id!)")
        request.predicate = predicate
        
        do {
            
            let fetchedUsers = try context.fetch(request)
            
            if fetchedUsers.count > 0 {
                fetchedUsers[0].name = coreDataUser.name!
                fetchedUsers[0].birthdate = Utils.fromStringToDate(date: coreDataUser.birthdate!) as NSDate
                
                try context.save()
            }
            else {
                insertCoreDataUser(coreDataUser: coreDataUser)
            }
            
        } catch {
            print("Error while updating user with id \(coreDataUser.id ?? 0) from Core Data")
        }
        
    }

    
    
    
    // get all students
    func getUsers(name: String) -> [CoreDataUser]? {
        
        var context: NSManagedObjectContext
        
        if #available(iOS 10.0, *) {
            context = stack.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            context = stack.managedObjectContext
        }
        let request : NSFetchRequest<User> = User.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "name contains[c] %@", name)
        request.predicate = predicate
        
        do {
            
            let fetchedUsers = try context.fetch(request)
            
            var allUsers: [CoreDataUser] = [CoreDataUser]()
            
            for fetchedUser in fetchedUsers {
                allUsers.append(fetchedUser.mappedObject())
            }

            return allUsers.count > 0 ? allUsers : nil
            
        } catch {
            print("Error while getting users like \(name) from Core Data")
            return nil
        }
        
    }
    
    
    
    
    // get all students
    func getUser(id: Int16) -> CoreDataUser? {
        
        var context: NSManagedObjectContext
        
        if #available(iOS 10.0, *) {
            context = stack.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            context = stack.managedObjectContext
        }
        let request : NSFetchRequest<User> = User.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "id = %@", "\(id)")
        request.predicate = predicate
        
        do {
            
            let fetchedUsers = try context.fetch(request)
            
            if fetchedUsers.count > 0 {
                return fetchedUsers[0].mappedObject()
            } else {
                return nil
            }
            
        } catch {
            print("Error while getting users with id \(id) from Core Data")
            return nil
        }
        
    }

    
    
    
    
    
    // get all students
    func getAllUsers() -> [CoreDataUser]? {
        
        var context: NSManagedObjectContext
        
        if #available(iOS 10.0, *) {
            context = stack.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            context = stack.managedObjectContext
        }
        let request : NSFetchRequest<User> = User.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            
            let fetchedUsers = try context.fetch(request)
            
            var allUsers: [CoreDataUser] = [CoreDataUser]()
            
            for fetchedUser in fetchedUsers {
                allUsers.append(fetchedUser.mappedObject())
            }
            
            return allUsers.count > 0 ? allUsers : nil
            
        } catch {
            print("Error while getting all users from Core Data")
            return nil
        }
        
    }

    
    
    // delete user with iD
    func deleteUser(id: Int16)
    {
        var context: NSManagedObjectContext
        
        if #available(iOS 10.0, *) {
            context = stack.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            context = stack.managedObjectContext
        }
        let request : NSFetchRequest<User> = User.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "id = %@", "\(id)")
        request.predicate = predicate
        
        do {
            
            let fetchedUsers = try context.fetch(request)
            
            if fetchedUsers.count > 0 {
                context.delete(fetchedUsers[0])
                
                try context.save()
                print("user removed successfully from Core Data")
            }
            
        } catch {
            print("Error while deleting users with id \(id) from Core Data")

        }

    }

    
    
    // delete ALL users
    func resetAllRecords()
    {
        var context: NSManagedObjectContext
        
        if #available(iOS 10.0, *) {
            context = stack.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            context = stack.managedObjectContext
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for result in results {
                context.delete(result)
            }
            try context.save()
            print("Core Data removed successfully!")
        } catch {
            print("fetch error removing from CoreData-\(error.localizedDescription)")
        }
    }


    
    
}

extension User {
    
    func mappedObject() -> CoreDataUser {
        return CoreDataUser(id: self.id, name: self.name, birthdate: Utils.fromDateToString(date: self.birthdate! as Date) )
    }
    
}
