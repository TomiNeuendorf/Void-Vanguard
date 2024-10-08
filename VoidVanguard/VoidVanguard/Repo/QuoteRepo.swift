//
//  QuoteRepo.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 30.09.24.
//

import Foundation

class QuoteRepo {
    
    func fetchQuotes() async throws -> Quote {
        let envKey = "api_key"
        guard let apiKey = ProcessInfo.processInfo.environment[envKey] else {
            throw QuoteAPIError.missingAPIKey(envKey: envKey)
        }
        
        let urlString = "https://api.api-ninjas.com/v1/quotes?category=funny"
        guard let url = URL(string: urlString) else {
            throw QuoteAPIError.invalidURL(url: urlString)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpUrlResponse = response as? HTTPURLResponse else {
            throw QuoteAPIError.responseTypecastingError(response: response)
        }
        
        guard case 200...299 = httpUrlResponse.statusCode else {
            throw QuoteAPIError.httpErrorCode(code: httpUrlResponse.statusCode)
        }
        
        let qoutes = try JSONDecoder().decode([Quote].self, from: data).first
        guard let qoute = qoutes else{
            throw QuoteAPIError.decodeError
        }
        return qoute
    }
    
    
}


enum QuoteAPIError: Error {
    case missingAPIKey(envKey: String)
    case invalidURL(url: String)
    case responseTypecastingError(response: URLResponse)
    case httpErrorCode(code: Int)
    case decodeError
    
    var description: String {
        switch self {
        case .missingAPIKey(envKey: let envKey):
            "Could not find API-Key for Movies API under env-key '\(envKey)'"
        case .invalidURL(url: let url):
            "Could not create a valid url object from url '\(url)'"
        case .responseTypecastingError(response: let response):
            "Could not typecast response '\(response)' to HttpUrlResponse"
        case .httpErrorCode(code: let code):
            "Received non-success error code '\(code)'"
        case .decodeError:
            "Unable to Decode"
        }
    }
}


