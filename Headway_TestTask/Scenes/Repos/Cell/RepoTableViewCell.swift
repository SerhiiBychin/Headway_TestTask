//
//  RepoTableViewCell.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 28.10.2020.
//

import UIKit
import Nuke

class RepoTableViewCell: UITableViewCell {
    @IBOutlet private (set) var repoNameLabel: UILabel!
    @IBOutlet private (set) var repoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withImageUrl url: String?,
                   name: String) {
        if let url = url {
            Nuke.loadImage(with: URL(string: url)!, into: repoImageView)
        }
        repoNameLabel.text = name
    }
}

extension RepoTableViewCell {
    func configure(withRepoItem item: RepoItem) {
        configure(withImageUrl: item.imageUrl,
                  name: item.name)
    }
}

