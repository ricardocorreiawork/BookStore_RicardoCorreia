//
//  BKService.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 27/01/2023.
//

import UIKit

class BKService {
    
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    private static let scheme = "https"
    private static let host = "www.googleapis.com"
    
    private let session: URLSession = .shared
    
    var urlPath: String { "" }
    
    private func makeURL(with queryItems: [URLQueryItem]) -> URL?
    {
        var components = URLComponents()
        components.scheme = BKService.scheme
        components.host = BKService.host
        components.path = urlPath
        components.queryItems = queryItems
        
        return components.url
    }
    
    func makeRequest<T: Decodable>(httpMethod: HTTPMethod,
                                   queryItems: [URLQueryItem],
                                   responseType: T.Type,
                                   completion: @escaping (T) -> Void)
    {
        guard let url = makeURL(with: queryItems) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("Error")
                return
            }
            
            // Decode JSON response
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(responseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
                
                // For debugging
                let printableJSON = try JSONSerialization.jsonObject(with: data)
                print(printableJSON)
            } catch {
                print("Error decoding JSON")
            }
        }
        
        task.resume()
    }
    
    func loadImage(from link: String, completion: @escaping (UIImage?) -> Void)
    {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }
    
}
