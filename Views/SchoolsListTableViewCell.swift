//
//  SchoolsListTableViewCell.swift
//  JpmInterview
//
//  Created by Gurubaran on 12/5/22.
//

import Foundation
import UIKit

class SchoolsListTableViewCell: UITableViewCell {
    @IBOutlet weak var schoolName: UILabel!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .lightGray
    }

    func configure(with schoolsList: SchoolsList?) {
        if let schoolsList = schoolsList {
            schoolName.alpha = 1
            schoolName.text = schoolsList.schoolName
            indicatorView.stopAnimating()
        } else {
            schoolName.alpha = 0
            indicatorView.startAnimating()
        }
    }
}
