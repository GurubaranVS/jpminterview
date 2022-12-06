//
//  SchoolListViewModel.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation

protocol SchoolListViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class SchoolListViewModel {
    private weak var delegate: SchoolListViewModelDelegate?
    
    private var schoolsList: [SchoolsList] = []
    private var currentOffset = 0
    private var total = 0
    private var isFetchInProgress = false
    
    let client = SchoolsListService()
    init(delegate: SchoolListViewModelDelegate) {
        self.delegate = delegate
    }
    
    // Since the API Response does not have a total param, I am hardcoding this from the data set value.
    // We can calculate this value by adding with each call but tableview performance might degrade hence taking a hard coded value
      var totalCount: Int {
        return 440
      }
    
    var currentCount: Int {
        return schoolsList.count
    }
    
    func school(at index: Int) -> SchoolsList {
        return schoolsList[index]
    }
    
    func fetchSchoolsPaginatedCall() {
        // 1
        guard !isFetchInProgress else {
            return
        }
        
        // 2
        isFetchInProgress = true
        client.fetchSchools(from: currentOffset) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentOffset += 20
                    // 2 TODO : What is the total here and how to modify this value
//                    self.total = response.schools.count
                    self.isFetchInProgress = false
                    self.schoolsList.append(contentsOf: response.schools)
                    
                    if self.currentOffset > 20 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(offset: self.currentOffset, currentSchoolsCount: response.schools.count)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(offset: Int, currentSchoolsCount: Int) -> [IndexPath] {
        let endIndex = offset + currentSchoolsCount
        return (offset..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
