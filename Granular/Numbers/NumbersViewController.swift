//
//  NumbersViewController.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/3/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class NumbersViewController: UIViewController {

    var numbersViewModel = NumbersViewModel()
    @IBOutlet weak var numbersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numbersViewModel.getAllNumbers { [weak self] (success, message) in
            if success {
                DispatchQueue.main.async {
                    self?.numbersTableView.reloadData()
                }
            } else {
                //Display error alert
            }
        }
    }    
}

extension NumbersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbersViewModel.getCountOfNumberModels()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NumberCell else {
            fatalError("Cell dequeue error")
        }
        
        if let numberCellViewModel = numbersViewModel.getNumberCellViewModels(indexPaths: [indexPath])?.first {
            cell.configureCell(numberCellViewModel: numberCellViewModel)
        }
        
        return cell
    }
}

extension NumbersViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        if let numberCellViewModels = numbersViewModel.getNumberCellViewModels(indexPaths: indexPaths) {
            for numberCellViewModel in numberCellViewModels {
                numberCellViewModel.getImage(completionHandler: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        if let numberCellViewModels = numbersViewModel.getNumberCellViewModels(indexPaths: indexPaths) {
            for numberCellViewModel in numberCellViewModels {
                numberCellViewModel.cancelDownload()
            }
        }
    }
}
