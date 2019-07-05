//
//  NumberModel.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/3/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class NumberModel: Codable {
    var name: String?
    var url: String?
    var image: UIImage?
    var downloadTask: URLSessionDataTask?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    func getCompleteURL() -> String {
        //"https://cdn.wallpapersafari.com/37/95/P05KU1.jpg"
        return "https://raw.githubusercontent.com/granularag/granular_mobile_mock_response/master/" + (url ?? "")
    }
}

