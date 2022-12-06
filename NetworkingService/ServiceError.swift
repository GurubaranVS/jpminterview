//
//  ServiceError.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation

enum ServiceError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "Network error, unable to fetch data"
        case .decoding:
            return "Decode error, unable to decode data"
        }
    }
}

