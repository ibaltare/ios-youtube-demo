//
//  Model.swift
//  youtube-demo
//
//  Created by Nicolas on 02/05/23.
//

import Foundation

protocol ModelDelegate {
    func videosFetched(_ videos: [Video])
}

class Model {
    
    var delegate: ModelDelegate?
    
    func getVideos() {
        // Create a URL bject
        let url = URL(string: Constants.API_URL)
        
        guard url != nil else {
            return
        }
        
        // Get a URLSession object
        let session = URLSession.shared
        
        //Get a data task from the URLSession object
        let dataTask = session.dataTask(with: url!) { data, response, error in
            //check if there were any errors
            if error != nil || data == nil {
                return
            }
            
            do {
                //Parsing the data into video object
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(Response.self, from: data!)
                
                if response.items != nil {
                    DispatchQueue.main.async {
                        self.delegate?.videosFetched(response.items!)
                    }
                    
                }
                //dump(response)
            } catch {
                
            }
            
            
        }
        
        dataTask.resume()
    }
    
}
