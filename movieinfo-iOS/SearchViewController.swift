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
        
        if let overviewLabel = cell.viewWithTag(13) as? UILabel {
            let sentences = movie.overview.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)
            overviewLabel.text = (sentences.first.map(String.init) ?? "") + "."
        }
        
        if let dateLabel = cell.viewWithTag(14) as? UILabel {
            dateLabel.text = movie.release_date
        }
            
        return cell
    }

    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform the segue
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.movie = searchResults[indexPath.row]
            }
        }
    }

}
