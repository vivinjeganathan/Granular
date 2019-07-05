//
//  NumberTableViewCell.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/3/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class NumberCell: UITableViewCell {

    var numberCellViewModel: NumberCellViewModel?
    
    override func prepareForReuse() {
        self.numberCellViewModel?.cancelDownload()
        self.imageView?.image = UIImage(named: "placeholder")
        print("cancelled in prepareForReuse - ", numberCellViewModel?.numberModel.getCompleteURL() ?? "Empty url")
        super.prepareForReuse()
    }
    
    func configureCell(numberCellViewModel: NumberCellViewModel) {
        
        self.numberCellViewModel = numberCellViewModel
        textLabel?.text = numberCellViewModel.getTitle()
        self.imageView?.image = UIImage(named: "placeholder")
        
        requestImage()
    }

    func requestImage() {
        
        print("Image requested - ", numberCellViewModel?.numberModel.getCompleteURL() ?? "Empty url")
        numberCellViewModel?.getImage { [weak self] (image, url, error) in
            
            print("Trying to Image set - ", url ?? "Empty url")
            if url == self?.numberCellViewModel?.numberModel.getCompleteURL() {
                DispatchQueue.main.async {
                    self?.imageView?.image = image
                    print("Image set - ", url ?? "Empty url")
                }
            } else {
                print("Wrong URL", url ?? "Empty url")
            }
        }
    }
}

