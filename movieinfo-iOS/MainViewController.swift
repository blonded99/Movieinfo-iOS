//
//  ViewController.swift
//  movieinfo-iOS
//
//  Created by 김병훈 on 2023/06/16.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // Instance of CSVLoader to load movies
    let loader = CSVLoader(filename: "movies_metadata")
    // An array to hold the loaded movies
    var movies = [Movie]()
    // An array to hold the top 20 movies
    var topMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load movies from CSV file
        loadMovies()
        
        // Sort movies by popularity
        sortMoviesByPopularity()
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // Load movies using the CSVLoader
    func loadMovies() {
        movies = loader.load()
    }
    
    // Sort movies by popularity and update topMovies
    func sortMoviesByPopularity() {
        movies.sort { $0.popularity > $1.popularity }
        topMovies = Array(movies.prefix(20))
    }

    // Sort movies by vote count and update topMovies
    func sortMoviesByVoteCount() {
        movies.sort { $0.vote_count > $1.vote_count }
        topMovies = Array(movies.prefix(20))
    }

    // Sort movies by vote average and update topMovies
    func sortMoviesByVoteAverage() {
        let sortedMovies = movies.filter { $0.vote_count >= 1000 }.sorted { $0.vote_average > $1.vote_average }
        topMovies = Array(sortedMovies.prefix(20))
    }


    @IBAction func sortValueChanged(_ sender: UISegmentedControl) {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0:
            sortMoviesByPopularity()
        case 1:
            sortMoviesByVoteCount()
        case 2:
            sortMoviesByVoteAverage()
        default:
            break
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)

        if let label = cell.viewWithTag(1) as? UILabel {
            let movie = topMovies[indexPath.row]
            label.text = movie.title
        }

        return cell
    }


}

