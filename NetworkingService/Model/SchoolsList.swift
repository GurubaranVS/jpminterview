//
//  SchoolsList.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation

struct SchoolsList: Codable {
    let schoolName: String
    let dbn: String
    let city: String
    let stateCode: String
    
    // We can also do this via Decoding strategy instead of writing down the below matching but I prefer this way
    
    enum CodingKeys: String, CodingKey {
        case dbn, city
        case schoolName = "school_name"
        case stateCode = "state_code"
    }
}
