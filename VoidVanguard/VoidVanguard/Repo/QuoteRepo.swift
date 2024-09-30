//
//  QuoteRepo.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 27.09.24.
//

import Foundation

class QuoteRepo {
    func fetchQuote() async throws -> [Quote] {
        guard let url = URL(string: "https://ultima.rest/api/quotes/random") else {
            throw QuoteRepoError.invalidURL
        }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            throw QuoteRepoError.requestFailed
        }
        guard let result = try? JSONDecoder().decode([Quote].self, from: data) else {
            throw QuoteRepoError.failedParsing
        }
        return result
    }
}

enum QuoteRepoError: Error {
    case invalidURL
    case requestFailed
    case failedParsing
    
    var description: String {
        switch self {
        case .invalidURL:
            return "The provided URL is not valid"
        case .requestFailed:
            return "The request failed"
        case .failedParsing:
            return "The data could not be parsed"
        }
    }
}

