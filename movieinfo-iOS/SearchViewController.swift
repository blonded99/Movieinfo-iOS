//
//  MainViewController.swift
//  movieinfo-iOS
//
//  Created by 김병훈 on 2023/06/17.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var searchResults: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        performSearch()
    }
    
    func performSearch() {
        guard let searchText = searchTextField.text else {
            return
        }
        
        searchResults.removeAll()
        
        switch searchTypeSegmentedControl.selectedSegmentIndex {
        case 0: // MovieTitle
            searchResults = MovieDataStore.shared.movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        case 1: // ActorName
            searchResults = MovieDataStore.shared.movies.filter { movie in
                movie.cast.contains(where: { $0.lowercased().contains(searchText.lowercased()) })
            }
        default:
            break
        }
        
        tableView.reloadData()
    }

    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        
        if let titleLabel = cell.viewWithTag(10) as? UILabel{
            let movie = searchResults[indexPath.row]
            titleLabel.text = movie.title
            if let posterImageView = cell.viewWithTag(11) as? UIImageView {
                    posterImageView.image = UIImage(named: "testImg")
                }
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Implement the navigation to Movie Detail Screen
    }
}
