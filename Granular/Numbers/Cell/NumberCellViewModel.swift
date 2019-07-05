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
    
    func getImage(completionHandler:((UIImage?, String?, Error?) -> Void)?) {
        
        if let numberImage = numberModel.image {
            //Cached image is returned
            print("Image already downloaded - ", numberModel.getCompleteURL())
            completionHandler?(numberImage, numberModel.getCompleteURL(), nil)
            return
        }
        
        
        if numberModel.downloadTask == nil || numberModel.downloadTask!.state == .completed || numberModel.downloadTask!.state == .canceling {
            print("Download Task created - ", numberModel.getCompleteURL())
            numberModel.downloadTask = numbersNetworkHelper.getNumberImage(numberModel: numberModel)
        }
        
        numbersNetworkHelper.imageDownloadCompletion = { (numberModel, error) in
            print("Download Completed - ", numberModel?.getCompleteURL() ?? "Empty url")
            completionHandler?(numberModel?.image, numberModel?.getCompleteURL(), nil)
        }

        numberModel.downloadTask?.resume()
    }
    
    func cancelDownload() {
        numberModel.downloadTask?.cancel()
    }
}
