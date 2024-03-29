//
//  NumbersViewModel.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/3/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class NumbersViewModel: NSObject {
    
    var numberModels : [NumberModel]?
    var numberCellViewModels: [NumberCellViewModel]?
    
    //Error handling needs to be improvised
    func getAllNumbers(completionHandler: @escaping ((Bool, String) -> Void)) {
        
        NumbersDataHelper.sharedInstance.getAllNumbers { [weak self] (result) in
            
            switch result {
                
            case .success(let numbers):
                self?.numberModels = numbers
                self?.createNumberCellViewModels()
                completionHandler(true, "")
            case .failure:
                //Message has to come from Localization strings
                completionHandler(false, "Sorry cannot complete the request at this time. Please try again.")
            }
        }
    }
    
    func getCountOfNumberModels() -> Int {
        return numberModels?.count ?? 0
    }
    
    func getNumberCellViewModels(indexPaths: [IndexPath]) -> [NumberCellViewModel]? {
        if (indexPaths.count > 0 && numberCellViewModels != nil && indexPaths.first!.row <= indexPaths.last!.row) {
          return Array(numberCellViewModels![indexPaths.first!.row...indexPaths.last!.row])
        }
        return nil
    }
    
    func createNumberCellViewModels() {
        numberCellViewModels = numberModels?.map { NumberCellViewModel(numberModel: $0) }
    }
}
