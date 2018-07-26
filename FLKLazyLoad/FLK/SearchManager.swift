//
//  SearchManager.swift
//  FLK
//
//  Created by Yu, Huiting on 6/8/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import Foundation

class SearchManager {
    
    enum SearchError: Error {
        //TODO: add error description so the ViewController can display it to the user
        case invalidQuery
        case invalidDataInResponse
        case noMoreData
        case unknown
    }
    
    enum SearchResult {
        case success([Photo])
        case failure(SearchError)
    }
    
    private var page = 1
    private var totalPages: Int?
    
    func request(keyword: String, resetPage: Bool, completion: @escaping (SearchResult)->Void) {
        if resetPage {
            page = 1
        }
        if let total = totalPages, page == total {
            completion(.failure(.noMoreData))
            return
        }
        //TODO: refactor, don't hardcode, move default url queries out, construct URL by URLComponents
        let plainstr = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text=\(keyword)&extras=url_s&format=json&nojsoncallback=1&page=\(page)"
        let escaped = plainstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlStr = escaped, let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let this = self else { return }
            var result = SearchResult.failure(.unknown)
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            guard let data = data else {
                result = .failure(.invalidDataInResponse)
                return
            }
            do {
                let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                result = .success(searchResponse.photos.photoArr.filter { $0.url != nil })
                this.page += 1
                this.totalPages = searchResponse.photos.pages
            } catch let error {
                if let error = error as? SearchError {
                    result = .failure(error)
                } else {
                    print(error)
                    result = .failure(.unknown)
                }
            }
        }.resume()
        
    }
}

fileprivate struct SearchResponse: Decodable {
    let photos: PhotoResponse
    
    fileprivate struct PhotoResponse: Decodable {
        let photoArr: [Photo]
        let page: Int
        let pages: Int
        
        enum CodingKeys: String, CodingKey {
            case photoArr = "photo"
            case page
            case pages
        }
    }
}
