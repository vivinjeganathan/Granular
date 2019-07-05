//
//  NumbersDataHelper.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/4/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

//This class has the swicth to get the data from Coredata/Network

class NumbersDataHelper: NSObject {
    
    static let sharedInstance = NumbersDataHelper()
    let coreDataHelper = CoreDataHelper.sharedInstance
    
    private override init() {
        super.init()
    }
    
    func getAllNumbers(completionHandler: @escaping ((Result<[NumberModel], GranularError>) -> Void)) {
        
        let numberModels = coreDataHelper.retrieveAllNumbers()
        
        if numberModels.count > 0 {
            completionHandler(.success(numberModels))
        } else {
            NumbersNetworkHelper().getAllNumbers { (result) in
                
                switch result {
                case .success(let numbers):
                    CoreDataHelper.sharedInstance.saveAllNumbers(numberModels: numbers)
                    completionHandler(.success(numbers))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
