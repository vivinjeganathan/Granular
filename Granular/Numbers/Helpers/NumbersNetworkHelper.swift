//
//  NumbersNetworkHelper.swift
//  Granular
//
//  Created by Jeganathan, Vivin on 7/3/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

//TODO: 3. Use Result

enum GranularError: Error {
    case badURL
    case networkError
    case responseError
    case downloadError
}

class NumbersNetworkHelper: NSObject, URLSessionDelegate {
    
    static var allNumbersUrl = "https://raw.githubusercontent.com/granularag/granular_mobile_mock_response/master/list.json" //This has to come from plist/config file
    var imageDownloadCompletion: ((Result<NumberModel, GranularError>) -> Void)?
    
    func getAllNumbers(completionHandler: @escaping ((Result<[NumberModel], GranularError>) -> Void)) {
        
        guard let url = URL(string: NumbersNetworkHelper.allNumbersUrl) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        urlSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completionHandler(.failure(.networkError))
                return
            }
            
            if let data = data {
                do {
                    let numberModels = try JSONDecoder().decode([NumberModel].self, from: data)
                    completionHandler(.success(numberModels))
                } catch {
                    completionHandler(.failure(.responseError))
                }
                
            } else {
                completionHandler(.failure(.responseError))
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
                self?.imageDownloadCompletion?(.failure(.downloadError))
                return
            }
            
            if let data = data, let response = response {
                URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                numberModel.image = UIImage(data: data)
                self?.imageDownloadCompletion?(.success(numberModel))
            } else {
                self?.imageDownloadCompletion?(.failure(.responseError))
            }
        }
        return dataTask
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
