//
//  MovieDataStore.swift
//  movieinfo-iOS
//
//  Created by 김병훈 on 2023/06/18.
//

import Foundation

class MovieDataStore {
    // 공유할 데이터
    static let shared = MovieDataStore()

    var movies: [Movie] = []

    // 다른 인스턴스 생성 방지
    private init() {}

    func loadMovies() {
        let loader = CSVLoader(filename: "movies_metadata")
        movies = loader.load()
    }
}
