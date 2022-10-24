//
//  StargazersListViewController.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import UIKit
import Combine

class StargazersListViewController: BaseViewController {
    
    enum StargazersListViewModelSection: Int, CaseIterable, Hashable {
        case stargazers
    }
    
    typealias DataSource = UITableViewDiffableDataSource<StargazersListViewModelSection, Stargazer>
    typealias Snapshot = NSDiffableDataSourceSnapshot<StargazersListViewModelSection, Stargazer>
    
    static func create(with viewModel: StargazersListViewModel) -> StargazersListViewController {
        let viewController = StargazersListViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: Private Properties
    
    private var viewModel: StargazersListViewModel!
    private var dataSource: DataSource!
    
    // MARK: UI Elements
    
    @IBOutlet private weak var repoOwnerTextField: CancellableTextField!
    @IBOutlet private weak var repoNameTextField: CancellableTextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var fetchStargazersButton: UIButton!
    @IBOutlet private weak var emptyPlaceholderStackView: UIStackView!
    @IBOutlet private weak var emptyPlaceholderImageView: UIImageView!
    @IBOutlet private weak var emptyPlaceholderLabel: UILabel!
    @IBOutlet private weak var pullInfoView: UIView!
    private lazy var refreshControl = UIRefreshControl()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setUpDataSource()
        bind()
    }

    @objc func refresh(_ sender: AnyObject) {
        viewModel.fetchNextPage()
    }
}

// MARK: Private Methods

private extension StargazersListViewController {
    func setup() {
        view.backgroundColor = .Primary.dark
        
        tableView.register(xibCell: StargazerCell.self)
        tableView.contentInset.bottom = 20
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController

        fetchStargazersButton.addAction(for: .touchUpInside) { [weak self] in
            self?.fetchStargazers()
        }
    }
    
    func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView
        ) { [weak self] tableView, indexPath, _ in
            guard
                let self = self,
                let stargazer = self.viewModel.stargazers.value[safe: indexPath.row]
            else { return UITableViewCell() }
            
            let cell: StargazerCell = tableView.dequeueReusableCell(for: indexPath)
            cell.viewModel = stargazer
            
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    func updateServersList(animated: Bool = true) {
        refreshControl.endRefreshing()
        emptyPlaceholderStackView.isHidden = !viewModel.stargazers.value.isEmpty
        pullInfoView.isHidden = !emptyPlaceholderStackView.isHidden
        
        if viewModel.isValidRepo {
            emptyPlaceholderImageView.image = UIImage(systemName: "star.slash")
            emptyPlaceholderLabel.text = "No one has starred this repo (owner included!)."
        } else {
            emptyPlaceholderImageView.image = UIImage(systemName: "list.dash")
            emptyPlaceholderLabel.text = "Check who starred your favourite repositories."
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([.stargazers])
        snapshot.appendItems(
            viewModel.stargazers.value.elements,
            toSection: .stargazers
        )
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func bind() {
        viewModel.stargazers
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stargazers in
                self?.updateServersList()
            }
            .store(in: &bag)
        
        viewModel.error
            .receive(on: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] error in
                self?.showAlert(message: error)
            }
            .store(in: &bag)
    }
    
    func fetchStargazers() {
        guard
            let repoOwner = repoOwnerTextField.text,
            let repoName = repoNameTextField.text,
            !repoOwner.isEmpty,
            !repoName.isEmpty
        else {
            viewModel.clearStargazers()
            return
        }
        viewModel.fetchFirstPage(
            repoOwner: repoOwner,
            repoName: repoName
        )
    }
}
