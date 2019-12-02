//
//  apitest1.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/19/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Cocoa


class apiTest{
    let url = URL(string: "https://exampleapi.com/data.json")
    
    // create a url session
    let defaultSession = URLSession(configuration: .default)
    
    // create a data task
    var dataTask: URLSessionDataTask?
    
    typealias QueryResult = ([Track]?, String) -> Void
    var errorMessage = ""
    var tracks: [Track] = []

    func getSearchResults(searchTerm: String, completion: @escaping QueryResult)
    {
        // 1
        dataTask?.cancel()
            
        // 2
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
          urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
          // 3
          guard let url = urlComponents.url else {
            return
          }
          // 4
          dataTask =
            defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
              self?.dataTask = nil
            }
            // 5
            if let error = error {
              self?.errorMessage += "DataTask error: " +
                                      error.localizedDescription + "\n"
            } else if
              let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode == 200 {
              self?.updateSearchResults(data)
              // 6
              DispatchQueue.main.async {
                completion(self?.tracks, self?.errorMessage ?? "")
              }
            }
          }
          // 7
          dataTask?.resume()
        }

    }
    
    typealias JSONDictionary = [String: Any]

    private func updateSearchResults(_ data: Data) {
      var response: JSONDictionary?
      tracks.removeAll()
      
      do {
        response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
      } catch let parseError as NSError {
        errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
        return
      }
      
      guard let array = response!["results"] as? [Any] else {
        errorMessage += "Dictionary does not contain results key\n"
        return
      }
      
      var index = 0
      
      for trackDictionary in array {
        if let trackDictionary = trackDictionary as? JSONDictionary,
          let previewURLString = trackDictionary["previewUrl"] as? String,
          let previewURL = URL(string: previewURLString),
          let name = trackDictionary["trackName"] as? String,
          let artist = trackDictionary["artistName"] as? String {
            tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
            index += 1
        } else {
          errorMessage += "Problem parsing trackDictionary\n"
            }
        }
        
    }
}

class Track {
  //
  // MARK: - Constants
  //
  let artist: String
  let index: Int
  let name: String
  let previewURL: URL
  
  //
  // MARK: - Variables And Properties
  //
  var downloaded = false
  
  //
  // MARK: - Initialization
  //
  init(name: String, artist: String, previewURL: URL, index: Int) {
    self.name = name
    self.artist = artist
    self.previewURL = previewURL
    self.index = index
  }
}
