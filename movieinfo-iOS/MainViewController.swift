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
    @IBOutlet weak var genreSegmentedControl: UISegmentedControl!
    
    let loader = CSVLoader(filename: "movies_metadata")

    var movies = [Movie]()

    var topMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 불러오기
        MovieDataStore.shared.loadMovies()
        
        // 정렬
        sortMoviesByPopularity()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    //인기순
    func sortMoviesByPopularity() {
        let movies = filterMoviesBySelectedGenre().sorted { $0.popularity > $1.popularity }
        topMovies = Array(movies.prefix(20))
    }

    //평가 수 많은순
    func sortMoviesByVoteCount() {
        let movies = filterMoviesBySelectedGenre().sorted { $0.vote_count > $1.vote_count }
        topMovies = Array(movies.prefix(20))
    }

    //평점순
    func sortMoviesByVoteAverage() {
        let movies = filterMoviesBySelectedGenre().filter { $0.vote_count >= 1000 }.sorted { $0.vote_average > $1.vote_average }
        topMovies = Array(movies.prefix(20))
    }


    @IBAction func genreValueChanged(_ sender: UISegmentedControl) {
        sortMovies()
    }
    
    func filterMoviesBySelectedGenre() -> [Movie] {
        switch genreSegmentedControl.selectedSegmentIndex {
        case 1: // 코미디
            return MovieDataStore.shared.movies.filter { $0.genres.contains("Comedy") }
        case 2: // 로맨스
            return MovieDataStore.shared.movies.filter { $0.genres.contains("Romance") }
        case 3: // 액션
            return MovieDataStore.shared.movies.filter { $0.genres.contains("Action") }
        default: // 전체
            return MovieDataStore.shared.movies
        }
    }

    
    @IBAction func sortValueChanged(_ sender: UISegmentedControl) {
        sortMovies()
    }
    
    func sortMovies() {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailFromMain", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFromMain" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.movie = topMovies[indexPath.row]
            }
        }
    }



}

