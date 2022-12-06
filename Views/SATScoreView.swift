//
//  SATScoreView.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation
import UIKit

class SATScoreView: UIViewController {

    lazy var avgReadingScoreLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 45, y: 120, width: 200, height: 25))
        label.layer.cornerRadius = 7
        label.backgroundColor = .lightGray
        label.text = "SAT Score: "
        return label
    }()

    var dbn: String
    private var viewModel: SATScoreViewModel!
    public init(dbn: String) {
        self.dbn = dbn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SATScoreViewModel(delegate: self)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avgReadingScoreLabel)
        viewModel.fetchSATScore(forDbn: dbn)
    }

}

extension SATScoreView: SATScoreViewDelegate {
    func onFetchCompleted() {
        let satScore = viewModel.getSATScore()
        print(satScore.satMathAvgScore)
        avgReadingScoreLabel.text = "SAT Reading Avg Score: \(satScore.satCriticalReadingAvgScore)"
    }
    
    func onFetchFailed(with reason: String) {
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        let alertController = UIAlertController(title: title, message: reason, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    
}
