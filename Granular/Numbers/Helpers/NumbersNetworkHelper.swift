//
//  NumbersNetworkHelper.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/3/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

//TODO: 3. Use Result

class NumbersNetworkHelper: NSObject, URLSessionDelegate {
    
    static let sharedInstance = NumbersNetworkHelper()

    static var allNumbersUrl = "https://raw.githubusercontent.com/granularag/granular_mobile_mock_response/master/list.json" //This has to come from plist/config file
    
    private override init() {
        super.init()
    }
    
    func getAllNumbers(completionHandler: @escaping (([NumberModel]?, Error?) -> Void)) {
        
        guard let url = URL(string: NumbersNetworkHelper.allNumbersUrl) else {
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)

        urlSession.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let numberModels = try JSONDecoder().decode([NumberModel].self, from: data)
                    completionHandler(numberModels, nil)
                } catch {
                    completionHandler(nil, NSError(domain: "Network Error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Cannot decode"]))
                }
                
            } else {
                completionHandler(nil, NSError(domain: "Network Error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Data is nil"]))
            }
            
        }.resume()
    }
    
    func getNumberImage(numberModel: NumberModel, completionHandler: @escaping ((NumberModel?, Error?) -> Void)) -> URLSessionDataTask? {
        
        guard let url = URL(string: numberModel.getCompleteURL()) else {
            return nil
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
                if let error = error {
                    completionHandler(nil, error)
                    return
                }
                
                if let data = data {
                    numberModel.image = UIImage(data: data)
                    completionHandler(numberModel, nil)
                } else {
                    completionHandler(nil, NSError(domain: "Network Error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Data is nil"]))
                }
//            }
        }
        return dataTask
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
