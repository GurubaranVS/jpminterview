//
//  SATScoreService.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation
struct SATScoreResponse {
    let score: [SATScore]
}
final class SATScoreService {
    private lazy var baseURL: URL = {
        return URL(string: "hthttps://data.cityofnewyork.us/resource/f9bf-2cp4.json")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchSATScores(dbn: String, completion: @escaping (Result<SATScoreResponse, ServiceError>) -> Void) {
        let urlRequest = URLRequest(url: baseURL)
        
        let parameters = ["$where": "dbn=='01M448'"]
        
        let encodedURLRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.isValidResponseCode(),
                let data = data
            else {
                completion(Result.failure(ServiceError.network))
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode([SATScore].self, from: data) else {
                completion(Result.failure(ServiceError.decoding))
                return
            }
            
            completion(Result.success(SATScoreResponse(score: decodedResponse)))
        }).resume()
    }
}



