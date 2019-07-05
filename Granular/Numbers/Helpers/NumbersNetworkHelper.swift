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
    
    static var allNumbersUrl = "https://raw.githubusercontent.com/granularag/granular_mobile_mock_response/master/list.json" //This has to come from plist/config file
    var imageDownloadCompletion: ((NumberModel?, Error?) -> Void)?

    
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
    
    func getNumberImage(numberModel: NumberModel) -> URLSessionDataTask? {
        
        guard let url = URL(string: numberModel.getCompleteURL()) else {
            return nil
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        let request = URLRequest(url: url)

        let dataTask = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let error = error {
                if error._code == NSURLErrorCancelled {
                    return
                }
                self?.imageDownloadCompletion?(nil, error)
                return
            }
            
            if let data = data, let response = response {
                
                URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)

                numberModel.image = UIImage(data: data)
                self?.imageDownloadCompletion?(numberModel, nil)
            } else {
                self?.imageDownloadCompletion?(nil, NSError(domain: "Network Error", code: 1, userInfo: [NSLocalizedDescriptionKey : "Data is nil"]))
            }
        }
        return dataTask
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
