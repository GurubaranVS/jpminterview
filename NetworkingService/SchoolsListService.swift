//
//  SchoolsListService.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation
struct SchoolsListResponse {
    let schools: [SchoolsList]
}
final class SchoolsListService {
    private lazy var baseURL: URL = {
        return URL(string: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchSchools(from offset: Int, limit: Int = 20, completion: @escaping (Result<SchoolsListResponse, ServiceError>) -> Void) {
        let urlRequest = URLRequest(url: baseURL)
        
        let parameters = ["$select": "school_name,dbn,city,state_code", "$limit": "\(limit)", "$offset": "\(offset)"]
        
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
            
            guard let decodedResponse = try? JSONDecoder().decode([SchoolsList].self, from: data) else {
                completion(Result.failure(ServiceError.decoding))
                return
            }
            
            completion(Result.success(SchoolsListResponse(schools: decodedResponse)))
        }).resume()
    }
}



