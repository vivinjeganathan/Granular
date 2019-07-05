//
//  NumbersViewModelTests.swift
//  GranularTests
//
//  Created by Jeganathan, Vivin on 7/4/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import XCTest
@testable import Granular

class NumbersViewModelTests: XCTestCase {
    
    var numbersViewModel: NumbersViewModel!
    
    override func setUp() {
    
        let numberModel1 = NumberModel()
        numberModel1.name = "one"
        numberModel1.url = "url1"
        
        let numberModel2 = NumberModel()
        numberModel2.name = "two"
        numberModel2.url = "url2"
        
        numbersViewModel = NumbersViewModel()
        numbersViewModel.numberModels = [numberModel1, numberModel2]
    }
    
    func testGetCountOfNumberModels() {
        XCTAssertEqual(2, numbersViewModel.getCountOfNumberModels())
    }
    
    override func tearDown() {
        numbersViewModel = nil
    }
}
