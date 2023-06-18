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
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var myRatingLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMovieDetails()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            // 확인
            if let userRating = appDelegate.userRatings[movie?.id ?? -1] {
                myRatingLabel.text = "\(userRating)"
            } else {
                myRatingLabel.text = "N/A"
            }
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let movie = movie, let ratingText = ratingTextField.text else {
            return
        }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            appDelegate.userRatings[movie.id] = ratingText
        }
        myRatingLabel.text = "\(ratingText)"
    }
    
    func loadMovieDetails() {
        guard let movie = movie else { return }
        
        // 영화 이미지
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let fullUrlString = baseUrl + movie.poster_path
        if let fullUrl = URL(string: fullUrlString) {
            movieImage.load(url: fullUrl)
        }

        titleLabel.text = movie.title
        

        ratingLabel.text = "\(movie.vote_average)"
        
        let year = String(movie.release_date.prefix(4))
        yearLabel.text = year
        
 
        let runtime = Int(movie.runtime)
        timeLabel.text = "\(runtime) 분"

        
        isAdultLabel.text = movie.adult ? "청소년 관람불가" : "청소년 관람가능"
        
        genreLabel.text = movie.genres.prefix(3).joined(separator: ", ")
        
        castLabel.text = movie.cast.prefix(4).joined(separator: ", ")
        
        if let firstCompany = movie.production_companies.first {
            companyLabel.text = firstCompany
        }
    }

}
