//
//  SATScore.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation

struct SATScore: Codable {
    
    let dbn: String
    let schoolName: String
    let numOfSatTestTakers: String
    let satCriticalReadingAvgScore: String
    let satMathAvgScore: String
    let satWritingAvgScore: String
    
    // We can also do this via Decoding strategy instead of writing down the below matching but I prefer this
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case satCriticalReadingAvgScore = "sat_critical_reading_avg_score"
        case satWritingAvgScore = "sat_writing_avg_score"
        case satMathAvgScore = "sat_math_avg_score"
        case numOfSatTestTakers = "num_of_sat_test_takers"
        case schoolName = "school_name"
    }
}
