//
//  QuoteViewModel.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 27.09.24.
//

import Foundation

class QuoteViewModel: ObservableObject {
    
    @Published var quotes: [Quote] = []
    @Published var status: Status? {
        didSet {
            Task {
                await load()
            }
        }
    }
    
    init() {
        Task {
            await load()
        }
    }
    
    func load() async {
        status = .isLoading
        do {
            quotes = try await repository.fetchQuote()
        } catch {
            let error = error as! QuoteRepoError
            status = .error
            print("Could not load Quote data: \(error.description)")
        }
        status = .done
    }
    
    private let repository = QuoteRepo()
}
    
enum Status {
    case isLoading
    case error
    case done
}
