//
//  NumberCellViewModel.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/4/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class NumberCellViewModel: NSObject {
    
    var numberModel : NumberModel
    let numbersNetworkHelper = NumbersNetworkHelper()
    
    init(numberModel : NumberModel) {
        self.numberModel = numberModel
    }
    
    func getTitle() -> String {
        return numberModel.name ?? ""
    }
    
    func getImage(completionHandler:((UIImage?, String?) -> Void)?) {
        
        if let numberImage = numberModel.image {
            //Cached image is returned
            completionHandler?(numberImage, numberModel.getCompleteURL())
            return
        }
        
        //Covering edge cases - needs logic improvisation
        if numberModel.downloadTask == nil || numberModel.downloadTask!.state == .completed || numberModel.downloadTask!.state == .canceling {
            numberModel.downloadTask = numbersNetworkHelper.getNumberImage(numberModel: numberModel)
        }
        
        numbersNetworkHelper.imageDownloadCompletion = { [weak self] result in
            
            switch result {
            case .success(let numberModel):
                completionHandler?(numberModel.image, numberModel.getCompleteURL())
            case .failure:
                completionHandler?(nil, self?.numberModel.getCompleteURL())
            }
        }

        numberModel.downloadTask?.resume()
    }
    
    func cancelDownload() {
        numberModel.downloadTask?.cancel()
    }
}
