//
//  HTTPURLResponse.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation
extension HTTPURLResponse {
    func isValidResponseCode() -> Bool {
        return (200...299).contains(self.statusCode)
    }
}
