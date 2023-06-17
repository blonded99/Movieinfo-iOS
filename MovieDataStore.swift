//
//  MovieDataStore.swift
//  movieinfo-iOS
//
//  Created by 김병훈 on 2023/06/18.
//

import Foundation

class MovieDataStore {
    // Create the shared instance
    static let shared = MovieDataStore()

    // The array to hold the movies
    var movies: [Movie] = []

    // Prevent creating another instance
    private init() {}

    // Load movies using the CSVLoader
    func loadMovies() {
        let loader = CSVLoader(filename: "movies_metadata")
        movies = loader.load()
    }
}
