//
//  Utilities.swift
//  Weather
//
//  Created by Sumanth Pammi on 5/31/23.
//

import Foundation
import Combine

struct Utilites {
    
    /**
     - type: Generic type of class
     - from: response as data format
     - completion: returns the data moel or error
     */
    
    static func convertResponseToModel<T>(type: T.Type, from data: Data, completion:@escaping((T?, Error?) -> Void)) where T : Decodable {
        do{
            let dataModel = try JSONDecoder().decode(type, from: data)
            completion(dataModel,nil)
        }
        catch DecodingError.dataCorrupted(let context){
            completion(nil, context.underlyingError)
        }
        catch let err {
            completion(nil, err)
        }
    }
}

func toOptionalPublisher<T, E: Error>(_ input: AnyPublisher<T, E>?) -> AnyPublisher<T?, E> {
    if let i = input {
        let subject = PassthroughSubject<T?, E>.init()
        var cancellable: AnyCancellable?
        
        cancellable = i.sink { c in
            switch c {
            case .failure(let error):
                subject.send(completion: .failure(error))
            case .finished:
                subject.send(completion: .finished)
            }
            cancellable = nil
        } receiveValue: { value in
            subject.send(value)
        }

        let o2 = subject.handleEvents(
            receiveSubscription: nil,
            receiveOutput: nil,
            receiveCompletion: nil,
            receiveCancel: {
                cancellable?.cancel()
                cancellable = nil
            },
            receiveRequest: nil)
        
        return o2.eraseToAnyPublisher()
    } else {
        return Just<T?>(nil)
            .setFailureType(to: E.self)
            .eraseToAnyPublisher()
    }
}
