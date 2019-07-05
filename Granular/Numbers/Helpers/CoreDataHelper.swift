//
//  CoreDataHelper.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/4/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    static let sharedInstance = CoreDataHelper()
    
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private override init() {
        super.init()
    }
    
    func saveAllNumbers(numberModels: [NumberModel]) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Number", in: viewContext) else {
            return
        }
        
        for numberModel in numberModels {
            
            let number = NSManagedObject(entity: entity, insertInto: viewContext)
            number.setValue(numberModel.name, forKey: "name")
            number.setValue(numberModel.url, forKey: "url")
        }
        
        do {
            try viewContext.save()
        } catch  {
            
        }
    }
    
    func retrieveAllNumbers() -> [NumberModel] {
        
        var numberModels = [NumberModel]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Number")
        request.returnsObjectsAsFaults = false
        
        do {
            if let result = try viewContext.fetch(request) as? [NSManagedObject] {
                
                for number in result {
                    let numberModel = NumberModel()
                    numberModel.name = number.value(forKey: "name") as? String ?? ""
                    numberModel.url = number.value(forKey: "url") as? String ?? ""
                    
                    numberModels.append(numberModel)
                }
            }
        } catch {
            
        }
        
        return numberModels
    }
}
