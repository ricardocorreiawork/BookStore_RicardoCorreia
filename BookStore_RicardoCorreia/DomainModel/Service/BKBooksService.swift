//
//  BKBooksService.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 27/01/2023.
//

import Foundation

class BKBooksService: BKService {
    
    override var urlPath: String { "/books/v1/volumes" }
    
    func requestBooks(thatContain searchQuery: String,
                      maxResults: Int,
                      startIndex: Int,
                      completion: @escaping (BKBooksResponse) -> Void)
    {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "q", value: searchQuery),
            URLQueryItem(name: "maxResults", value: String(maxResults)),
            URLQueryItem(name: "startIndex", value: String(startIndex)),
        ]
        
        makeRequest(httpMethod: .get,
                    queryItems: queryItems,
                    responseType: BKBooksResponse.self,
                    completion: completion)
    }
    
}
