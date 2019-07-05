//
//  NumbersDataHelper.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/4/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class NumbersDataHelper: NSObject {
    
    static let sharedInstance = NumbersDataHelper()
    
    let coreDataHelper = CoreDataHelper.sharedInstance
    lazy var numbersNetworkHelper = NumbersNetworkHelper.sharedInstance
    
    private override init() {
        super.init()
    }
    
    func getAllNumbers(completionHandler: @escaping (([NumberModel]?, Error?) -> Void)) {
        
        let numberModels = coreDataHelper.retrieveAllNumbers()
        
        if numberModels.count > 0 {
            completionHandler(numberModels, nil)
        } else {
            numbersNetworkHelper.getAllNumbers { (numbers, error) in
                
                if let numbers = numbers {
                    CoreDataHelper.sharedInstance.saveAllNumbers(numberModels: numbers)
                }
                completionHandler(numbers, error)
            }
        }
    }
}
