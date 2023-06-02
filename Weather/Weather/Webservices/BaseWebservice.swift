//
//  BaseWebservice.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import Foundation

class BaseWebservice
{
    var apiError = NSError(domain: "", code: -1, userInfo: [kCFErrorLocalizedDescriptionKey as String : NSLocalizedString("Error in creating schools URL.", comment:"Error in creating schools URL")])
    init() { }
    
    func executeAPIRequest(url : URL, completion : @escaping (Data?, NSError?) -> Void)
    {
        let task = URLSession.shared.dataTask(with: url) { (responseData, response, error) in
            if error != nil {
                debugPrint("Error: Received Error.")
                completion(nil, self.apiError)
                return
            }
            completion(responseData, nil)
        }
        task.resume()
    }
    
}
