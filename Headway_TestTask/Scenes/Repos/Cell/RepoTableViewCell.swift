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
    func configure(withRepoItem item: RepoItemViewModel, selectedItems: [RepoItemViewModel]) {
        configure(withImageUrl: item.imageUrl,
                  name: item.name)
        self.backgroundColor = selectedItems.contains(where: { $0.id == item.id}) ? .lightGray : .clear
    }
}

