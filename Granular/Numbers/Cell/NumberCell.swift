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
        super.prepareForReuse()
        self.imageView?.image = UIImage(named: "placeholder")
    }
    
    func configureCell(numberCellViewModel: NumberCellViewModel) {
        
        self.numberCellViewModel = numberCellViewModel
        textLabel?.text = numberCellViewModel.getTitle()
        self.imageView?.image = UIImage(named: "placeholder")
        
        requestImage()
    }

    func requestImage() {
        
        numberCellViewModel?.getImage { [weak self] (image, url, error) in
            
            if url == self?.numberCellViewModel?.numberModel.getCompleteURL() {
                DispatchQueue.main.async {
                    self?.imageView?.image = image
                }
            } else {
                print("Wrong URL", url!)
            }
        }
    }
}
