//
//  ViewController.swift
//  Pokemon-Dictionary
//
//  Created by 오준솔 on 2022/10/19.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: SearchViewModel = SearchViewModel()
    
    var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Pokemon"
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Pokemon Dictionary"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Search text did changed
        searchController.searchBar.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] searchText in
                self?.viewModel.search(query: searchText)
            }.store(in: &cancellables)
        
        bind()
    }
    
    func bind() {
        viewModel.$searchedItems
            .receive(on: RunLoop.main)
            .sink {
                [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.fetchData()
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchedItems.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.viewModel.searchedItems[indexPath.row].name
        return cell
    }
}
