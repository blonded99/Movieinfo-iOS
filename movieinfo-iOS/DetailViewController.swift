//
//  DetailViewController.swift
//  movieinfo-iOS
//
//  Created by 김병훈 on 2023/06/17.
//

import UIKit

class DetailViewController: UIViewController {
    var movie: Movie?

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var isAdultLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadMovieDetails()
    }
    
    func loadMovieDetails() {
        guard let movie = movie else { return }
        
        // Movie image
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let fullUrlString = baseUrl + movie.poster_path
        if let fullUrl = URL(string: fullUrlString) {
            movieImage.load(url: fullUrl)
        }
        
        // Title
        titleLabel.text = movie.title
        
        // Rating
        ratingLabel.text = "\(movie.vote_average)"
        
        // Release date(years only)
        let year = String(movie.release_date.prefix(4))
        yearLabel.text = year
        
        // 4. Running time
        let runtime = Int(movie.runtime)
        timeLabel.text = "\(runtime) 분"

        
        // Is adult
        isAdultLabel.text = movie.adult ? "청소년 관람불가" : "청소년 관람가능"
        
        // Genres
        genreLabel.text = movie.genres.prefix(3).joined(separator: ", ")
        
        // Cast
        castLabel.text = movie.cast.prefix(4).joined(separator: ", ")
        
        // Production company
        if let firstCompany = movie.production_companies.first {
            companyLabel.text = firstCompany
        }
    }

}
