//
//  CoreDataHelper.swift
//  CoreDataPractice
//
//  Created by Moin Uddin on 10/30/14.
//  Copyright (c) 2014 Moin Uddin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    private class func directoryForDatabaseFilename()->NSURL{
        let urls: [NSURL] = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }
    
    private class func dataBaseFilename(name: String? = nil) ->String{
        if name != nil{
            return "\(name!).sqlite"
        }
        return "database.sqlite"
    }
    
    class func managedObjectContext(dataBaseFilename: String? = nil) -> NSManagedObjectContext{
        var error: NSError? = nil
        
        let url: NSURL = CoreDataHelper.directoryForDatabaseFilename().URLByAppendingPathComponent(CoreDataHelper.dataBaseFilename(dataBaseFilename))
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectModel)
        
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: mOptions)
            if (error != nil){
                print("Error: \(error?.localizedDescription)")
                abort()
            }
        } catch let error1 as NSError {
            error = error1
        }
        
        let managedObjectContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        //println(managedObjectContext)
        
        return managedObjectContext
    }
    
    class func insertManagedObject(className: NSString, managedObjectContext: NSManagedObjectContext) -> AnyObject{
        let managedObject: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(className as String, inManagedObjectContext: managedObjectContext)
        return managedObject
    }
    
    class func saveManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Bool{
        var error: NSError? = nil
        do {
            try managedObjectContext.save()
            return true
        } catch let error1 as NSError {
            error = error1
            print("Save Error: \(error?.localizedDescription)")
            return false
        }
    }
    
    class func fetchEntities(className: NSString, withPredicate predicate: NSPredicate?, andSorter sorter: NSArray?, managedObjectContext: NSManagedObjectContext, limit: Int? = nil, expressions: NSArray? = nil) -> NSArray{
        let fetchRequest: NSFetchRequest = NSFetchRequest()
        if limit != nil{
            fetchRequest.fetchLimit = limit!
        }
        let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(className as String, inManagedObjectContext: managedObjectContext)!
        fetchRequest.entity = entityDescription
        
        if (predicate != nil){
            fetchRequest.predicate = predicate!
        }
        if sorter != nil{
            fetchRequest.sortDescriptors = sorter! as? [NSSortDescriptor]
        }
        
        if expressions != nil{
            fetchRequest.propertiesToFetch = expressions! as [AnyObject]
            fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        var error: NSError? = nil
        do {
            let items: NSArray = try managedObjectContext.executeFetchRequest(fetchRequest)
            return items
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil{
            print("Fetch Error: \(error?.localizedDescription)")
            return []
        }
        return []
    }
    
    class func fetchEntitiesByGroup(className: NSString, managedObjectContext: NSManagedObjectContext, predicate: NSPredicate?, sorter: NSArray? = nil, groupBy: NSArray? = nil) -> NSArray{
        let fetchRequest: NSFetchRequest = NSFetchRequest()
        let entityDescription: NSEntityDescription = NSEntityDescription.entityForName(className as String, inManagedObjectContext: managedObjectContext)!
        
        fetchRequest.entity = entityDescription
        
        if predicate != nil{
            fetchRequest.predicate = predicate!
        }
        
        if sorter != nil{
            fetchRequest.sortDescriptors = sorter! as? [NSSortDescriptor]
        }
        
        if groupBy != nil{
            fetchRequest.propertiesToGroupBy = groupBy! as [AnyObject]
            fetchRequest.resultType = .DictionaryResultType
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        let items: NSArray = try! managedObjectContext.executeFetchRequest(fetchRequest)
        
        return items
    }
   
}
