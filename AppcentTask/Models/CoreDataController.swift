//
//  CoreDataController.swift
//  AppcentTask
//
//  Created by Said Çankıran on 14.11.2020.
//

import Foundation
import CoreData
import UIKit

class CoreDataController {
    static let run = CoreDataController()
    
    /**
     Check CoreData entity for game is favorited or vice versa.
     - Parameter id:Game ID
     - Returns: True if game favorited, False if game not favorited.
     */
    func checkCoreData(_ id:Int) -> Bool {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "FavoritedGames")
        
        //3
        do {
            let data = try managedContext.fetch(fetchRequest)
            for index in data {
                if index.value(forKey: "id") as! Int == id {
                    return true
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        return false
    }
    
    
    
    /**
     Fetch favorited games from CoreData
     - Parameter handler:Completion Handler
     - Returns: If there is an error return error. Otherwise return NSManagedObject array which has favorited games informations..
     */
    func getGames(handler: @escaping (_ result:[NSManagedObject]?,_ error:Error?)-> Void) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "FavoritedGames")
        
        //3
        do {
            let data = try managedContext.fetch(fetchRequest)
            handler(data,nil)
            
        } catch let error as NSError {
            let err:Error = error as Error
            handler(nil,err)
        }
    }
    
    
    /**
     Delete Game where CoreData.
     - Parameter id:Game ID
     - Returns: True if game favorited, False if game not favorited.
     */
    func deleteGame(_ id:Int) -> Bool{
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "FavoritedGames")
        
        //3
        do {
            let data = try managedContext.fetch(fetchRequest)
            for index in data {
                if index.value(forKey: "id") as! Int == id {
                    managedContext.delete(index)
                    try managedContext.save()
                    return true
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        return false

    }
    
    
    
    /// Save game to CoreData which favorited
    /// - Parameters:
    ///   - id: Game ID
    ///   - name: Game Name
    ///   - released: Game Released Date
    ///   - background_image: Game Image URL
    ///   - rating: Game Rating
    ///   - rating_top: Game Rating Max Level
    ///   - handler: Completion Handler
    func saveGame(_ id:Int,_ name:String,_ released:String,_ background_image:String, _ rating:Double,_ rating_top:Double,handler: @escaping (_ result:Any?,_ error:Error?) -> Void) {
          
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
          // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
          
          // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "FavoritedGames",
                                       in: managedContext)!
          
        let entry = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
          
          // 3
        let data:[String:Any] = [
            "id":id,
            "name":name,
            "released":released,
            "background_image":background_image,
            "rating":rating,
            "rating_top":rating_top,
        ]
            
            entry.setValuesForKeys(data)
          // 4
          do {
            try managedContext.save()
            handler(true,nil)
          } catch let error as NSError {
            handler(false,error as Error)
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
}
