//
//  MainViewController.swift
//  movieinfo-iOS
//
//  Created by 김병훈 on 2023/06/17.
//

import UIKit

// Extend UIImageView to add load function
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            } else {
                // In case image couldn't be loaded, set to a default image
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "testImg") // Change "testImg" to your default image name
                }
            }
        }
    }
}


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
        let movie = searchResults[indexPath.row]
        
        if let titleLabel = cell.viewWithTag(10) as? UILabel {
            titleLabel.text = movie.title
        }
        
        if let posterImageView = cell.viewWithTag(11) as? UIImageView {
            let baseUrl = "https://image.tmdb.org/t/p/w185"
            let fullUrlString = baseUrl + movie.poster_path
            if let fullUrl = URL(string: fullUrlString) {
                posterImageView.load(url: fullUrl)
            }
        }
        
        if let idLabel = cell.viewWithTag(12) as? UILabel {
            idLabel.text = "\(movie.id)"
        }
            
        return cell
    }

    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Implement the navigation to Movie Detail Screen
    }
}
