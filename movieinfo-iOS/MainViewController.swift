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
        MovieDataStore.shared.loadMovies()
        
        // Sort movies by popularity
        sortMoviesByPopularity()
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
    }
    
//    // Load movies using the CSVLoader
//    func loadMovies() {
//        movies = loader.load()
//    }
    
    // Sort movies by popularity and update topMovies
    func sortMoviesByPopularity() {
        let movies = MovieDataStore.shared.movies.sorted { $0.popularity > $1.popularity }
        topMovies = Array(movies.prefix(20))
    }

    // Sort movies by vote count and update topMovies
    func sortMoviesByVoteCount() {
        let movies = MovieDataStore.shared.movies.sorted { $0.vote_count > $1.vote_count }
        topMovies = Array(movies.prefix(20))
    }

    // Sort movies by vote average and update topMovies
    func sortMoviesByVoteAverage() {
        let movies = MovieDataStore.shared.movies.filter { $0.vote_count >= 1000 }.sorted { $0.vote_average > $1.vote_average }
        topMovies = Array(movies.prefix(20))
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

        if let titleLabel = cell.viewWithTag(1) as? UILabel,
           let ratingLabel = cell.viewWithTag(2) as? UILabel, let dateLabel = cell.viewWithTag(3) as? UILabel{
            let movie = topMovies[indexPath.row]
            titleLabel.text = movie.title
            ratingLabel.text = String(movie.vote_average)
            dateLabel.text = movie.release_date
        }

        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform the segue
        performSegue(withIdentifier: "showDetailFromMain", sender: self)
    }

    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailFromMain" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.movie = topMovies[indexPath.row]
            }
        }
    }



}

