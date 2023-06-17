//
//  CSVLoader.swift
//  movieinfo-iOS
//
//  Created by 김병훈 on 2023/06/17.
//

import Foundation


struct CSVLoader {
    let filename: String

    init(filename: String) {
        self.filename = filename
    }

    func load() -> [Movie] {
        guard let path = Bundle.main.path(forResource: self.filename, ofType: "csv") else {
            print("Unable to find CSV file.")
            return []
        }

        do {
            let csvData = try String(contentsOfFile: path, encoding: .utf8)
            let rows = csvData.components(separatedBy: "\n")
            var movies: [Movie] = []

            for (index, row) in rows.enumerated() {
                // 헤더는 skip
                guard index != 0 else { continue }

                var columns = [String]()
                var currentColumn = ""
                var insideQuotes = false

                for character in row {
                    if character == "\"" {
                        insideQuotes = !insideQuotes
                    } else if character == "," && !insideQuotes {
                        columns.append(currentColumn)
                        currentColumn = ""
                    } else {
                        currentColumn.append(character)
                    }
                }
                columns.append(currentColumn)

                guard columns.count > 15 else { continue }

                let movie = Movie(
                    adult: columns[0] == "True",
                    genres: parseArray(from: columns[1]),
                    imdb_id: Int(columns[2]) ?? 0,
                    original_language: columns[3].replacingOccurrences(of: "\'", with: ""),
                    overview: columns[4].replacingOccurrences(of: "\'", with: ""),
                    popularity: Double(columns[5]) ?? 0.0,
                    poster_path: columns[6],
                    production_companies: parseArray(from: columns[7]),
                    release_date: columns[8],
                    runtime: Double(columns[9]) ?? 0.0,
                    status: columns[10],
                    title: columns[11].replacingOccurrences(of: "\'", with: ""),
                    vote_average: Double(columns[12]) ?? 0.0,
                    vote_count: Double(columns[13]) ?? 0.0,
                    tmdbId: Double(columns[14]) ?? 0.0,
                    cast: parseArray(from: columns[15])
                )

                movies.append(movie)
            }

            return movies
        } catch let error {
            print("Error loading CSV: \(error)")
            return []
        }
    }

    private func parseArray(from string: String) -> [String] {
        let trimmed = string.trimmingCharacters(in: CharacterSet(charactersIn: "[]\""))
        let replaced = trimmed.replacingOccurrences(of: "\'", with: "")
        return replaced.components(separatedBy: ", ")
    }
}
