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
    
    private func bind() {
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink {
                error in
                print(error?.localizedDescription ?? "")
                //TODO:- Error Handling
            }.store(in: &cancellables)
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.viewModel.searchedItems[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.searchBar.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        let id = self.viewModel.searchedItems[indexPath.row].id
        let names = self.viewModel.items.filter{ $0.id == id }.map{ $0.name }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pokemonInfoVC = storyboard.instantiateViewController(withIdentifier: "PokemonInfoViewController") as! PokemonInfoViewController
        let pokemonInfoVM = PokemonInfoViewModel(id: id, names: names)
        pokemonInfoVC.viewModel = pokemonInfoVM
        self.present(pokemonInfoVC, animated: false)
        
    }
}
