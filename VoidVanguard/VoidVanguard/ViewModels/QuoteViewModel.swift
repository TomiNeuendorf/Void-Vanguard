//
//  QuoteViewModel.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 01.10.24.
//

import Foundation
import Observation

class QuoteViewModel: ObservableObject {
    
    @Published var quotes: Quote = Quote(category: "happyness", quote: "Nothing flatters a man as much as the happiness of his wife he is always proud of himself as the source of it.", author: "Samuel Johnson")
    var error: String? // Variable für Fehlermeldungen
    
    init(){
        load()
    }
    
    func load() {
        Task {
            do {
                self.quotes = try await repository.fetchQuotes()
                error = nil
                print("Quotes loaded successfully: \(quotes)")
            } catch let apiError as QuoteAPIError {
                error = apiError.description
                print(apiError.description)
            } catch {
                self.error = "Received an unexpected error: \(error)"
                print("Received an unexpected error: \(error)")
            }
        }
    }
    
    private let repository = QuoteRepo()
}
