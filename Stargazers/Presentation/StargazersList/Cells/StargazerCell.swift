//
//  StargazerCell.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import UIKit
import Nuke

class StargazerCell: UITableViewCell {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var starredAtLabel: UILabel!
    @IBOutlet private weak var githubUserImageView: UIImageView!
    
    var viewModel: Stargazer? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        githubUserImageView.image = UIImage(systemName: "person.fill")
    }
}

private extension StargazerCell {
    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        
        cardView.addShadow(size: .small)
        cardView.layer.cornerRadius = 10
        cardView.backgroundColor = .Primary.normal
        
        githubUserImageView.layer.cornerRadius = githubUserImageView.frame.size.height / 2
        githubUserImageView.layer.borderColor = UIColor.Secondary.normal.cgColor
        githubUserImageView.layer.borderWidth = 1
    }
    
    func configure() {
        loadImage()
        userNameLabel.text = viewModel?.user.userName
        starredAtLabel.text = "Starred on: \(viewModel?.starredAt?.dateString(ofStyle: .medium) ?? "")"
    }
    
    func loadImage() {
        guard let url = viewModel?.user.avatarURL else { return }
        Task {
            guard
                let response = try? await ImagePipeline.shared.image(for: url)
            else { return }
            githubUserImageView.image = response.image
        }
    }
}
