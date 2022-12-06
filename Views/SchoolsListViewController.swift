//
//  ViewController.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import UIKit

class SchoolsListViewController: UIViewController {

    private enum Identifier {
      static let cellIdentifier = "SchoolCell"
    }

    @IBOutlet weak var schoolsTable: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!    
    private var viewModel: SchoolListViewModel!
    
    private var shouldShowLoadingCell = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View did Load")
        indicatorView.startAnimating()
        schoolsTable.isHidden = true
        schoolsTable.separatorColor = .lightGray
        schoolsTable.dataSource = self
        schoolsTable.delegate = self
        schoolsTable.prefetchDataSource = self
        
        viewModel = SchoolListViewModel(delegate: self)
        
        viewModel.fetchSchoolsPaginatedCall()

    }


}

extension SchoolsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.cellIdentifier, for: indexPath) as! SchoolsListTableViewCell
        /// TODO Need to check this logic
        if indexPath.row >= viewModel.currentCount {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.school(at: indexPath.row))
        }
        return cell
    }
    
}


extension SchoolsListViewController: UITableViewDataSourcePrefetching {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= viewModel.currentCount
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            print("Prefetch data")
            viewModel.fetchSchoolsPaginatedCall()
        }
    }
    
    
}

extension SchoolsListViewController: SchoolListViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
          indicatorView.stopAnimating()
          schoolsTable.isHidden = false
          schoolsTable.reloadData()
          return
        }
        // TO DO explain in comment
//        let indexPathsToReload = Array(Set(schoolsTable.indexPathsForVisibleRows ?? []).intersection(newIndexPathsToReload))
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        schoolsTable.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        let alertController = UIAlertController(title: title, message: reason, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true)

    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
      let indexPathsForVisibleRows = schoolsTable.indexPathsForVisibleRows ?? []
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }
    
}

extension SchoolsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(viewModel.school(at: indexPath.row))
        let SATScoreView = SATScoreView(dbn: viewModel.school(at: indexPath.row).dbn)
        schoolsTable.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(SATScoreView, animated: true)
//        let satScore = SATScoreViewM
    }
}
