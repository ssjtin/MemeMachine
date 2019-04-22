//
//  SessionManager.swift
//  MemeMachine
//
//  Created by Hoang Luong on 3/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import Alamofire
import PromiseKit
import SwiftyJSON

let popularUrl = "http://version1.api.memegenerator.net//Generators_Select_ByPopular?pageIndex=0&pageSize=5&days="

let newUrl = "http://version1.api.memegenerator.net//Generators_Select_ByNew?pageIndex=0&pageSize=5"

let API_KEY = "&apiKey=9f0661f0-6d69-469f-ac14-9ffe221a1562"

class SessionManager {
    
    var urlString: String = popularUrl

    
    func retrieveImage(using object: ImageObject, completion: @escaping (UIImage?, Error?) -> ()) {
 
        if let image = imageCache.object(forKey: object.imageUrl as NSString)  {
            completion(image, nil)
            return
        }
        
        guard let url = URL(string: object.imageUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        firstly {
            Alamofire
                .request(request)
                .validate()
                .responseData()
            }.done { (response) in
                let image = UIImage(data: response.data)
                imageCache.setObject(image!, forKey: object.imageUrl as NSString)
                completion(image, nil)
            }.catch { (error) in
                completion(nil, error)
                print(error.localizedDescription)
        }
    }
    
    func fetchImages(pageIndex: Int, completion: @escaping ([ImageObject]) -> ()) {
        
        let baseUrlString = urlString + API_KEY
        let finalUrlString = baseUrlString.replacingOccurrences(of: "pageIndex=0", with: "pageIndex=\(pageIndex)")
        guard let url = URL(string: finalUrlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        firstly {
            Alamofire
                .request(request)
                .validate()
                .responseJSON()
            }.done { response in
                
                let json = JSON(response.response.data!)
                let results = json["result"]
                let decoder = JSONDecoder()
                var images = [ImageObject]()
                
                for result in results {
                    images.append(try decoder.decode(ImageObject.self, from: result.1.rawData()))
                }
                completion(images)
                
            }.catch { error in
                print(error.localizedDescription)
        }
    }


}
