//
//  SATScoreViewModel.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation

protocol SATScoreViewDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

final class SATScoreViewModel {
    private weak var delegate: SATScoreViewDelegate?
    
    private var satScore: [SATScore] = []
    
    let client = SATScoreService()
    init(delegate: SATScoreViewDelegate) {
        self.delegate = delegate
    }
    
    func fetchSATScore(forDbn: String) {
        client.fetchSATScores(dbn: forDbn) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.satScore = response.score
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }
    
    func getSATScore() -> SATScore {
        return self.satScore[0]
    }
    
}
