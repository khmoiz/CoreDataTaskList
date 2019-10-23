//
//  TaskController.swift
//  TaskList
//
//  Created by Moiz Khan on 2019-10-11.
//  Copyright © 2019 MK. All rights reserved.
//  Sheridan ID 9914774771 || UserName : khmoiz
//
import Foundation
import UIKit
import CoreData


public class TaskController{
    
    func insertTask(newTask: Task){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let taskEntity : NSEntityDescription? = NSEntityDescription.entity(forEntityName: "TaskEntity", in: managedContext)
        
   
        if (taskEntity != nil){
            let task = NSManagedObject(entity: taskEntity!, insertInto: managedContext)
            
            task.setValue(newTask.title, forKey: "title")
            task.setValue(newTask.subtitle, forKey: "subtitle")
            task.setValue(false, forKey: "done")
            
            
            do{
                //to perform insert operation on database table
                try managedContext.save()
                
            }catch let error as NSError{
                print("Insert task failed...\(error), \(error.userInfo)")
            }
        }
    }
    
    func updateTask(task : Task, newTask: Task){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", task.title)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            let existingTask = result[0] as! NSManagedObject
            
            existingTask.setValue(newTask.title, forKey: "title")
            existingTask.setValue(newTask.subtitle, forKey: "subtitle")
            
            do{
                try managedContext.save()
                print("Task update Successful")
            }catch{
                print("Task update unsuccessful")
            }
        }catch{
            print("Task update unsuccessful")
        }
        
    }
    
    func updateTaskDone(task : Task){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", task.title)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            let existingTask = result[0] as! NSManagedObject
            
            existingTask.setValue(task.done, forKey: "done")
            
            do{
                try managedContext.save()
                print("Task update Successful")
            }catch{
                print("Task update unsuccessful")
            }
        }catch{
            print("Task update unsuccessful")
        }
        
    }
    
    func deleteTask(task: Task){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", task.title)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let existingTask = result[0] as! NSManagedObject
            
            managedContext.delete(existingTask)
            
            do{
                try managedContext.save()
                print("Task delete Successful")
            }catch{
                print("Task delete unsuccessful")
            }
            
        }catch{
            
        }
        
        
    }
    
    
    
    func getAllTasks() -> [NSManagedObject]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            return result as? [NSManagedObject]
        }catch{
            print("Data fetching Unsuccessful")
        }
        return nil
    }
}
