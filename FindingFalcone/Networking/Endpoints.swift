//
//  Endpoints.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 21/07/22.
//

import Foundation

protocol Endpoints {
    var baseUrl : String { get }
    var url : String { get }
    var headers : [String : Any]? { get }
    var authenticationToken : String? { get }
    var parameters : [String : Any]? { get }
    var method : String { get }
    var body : Data? { get }
}


typealias ValidServerResponse<T : Codable> =  T
typealias WebResponse<ValidServerResponse> = (Result<ValidServerResponse, APIErrors>) -> Void


//MARK: - Common Properties and Configurations
extension Endpoints {
    
    var baseUrl : String {
        return Constants.Defaults.baseURL
    }
    
    var authenticationToken : String? {
        return UserDefaultManager.shared.authToken
    }
}

//MARK: - Webservice Interaction Method
extension Endpoints {
    
    private func printRequest(_ api: Endpoints) {
        debugPrint("********************************* API Request **************************************")
        debugPrint("Request URL:\(api.url)")
        debugPrint("Request Parameters: \(api.parameters ?? [:])")
        debugPrint("Request Headers: \(api.headers ?? [:])")
    }
    
    // MARK: - Server request using generics.
    func request<ValidServerResponse>(response completion : @escaping WebResponse<ValidServerResponse>) where ValidServerResponse : Codable {

        guard let url = URL(string : self.url) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.httpMethod = self.method
        if let body = self.body {
            request.httpBody = body
        }
        
        for (key,value) in self.headers ?? [:] {
            if let _val = value as? String {
                request.addValue(_val, forHTTPHeaderField: key)
            }
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            // Check the response
            debugPrint(response as Any)
            
            // Check if an error occured
            if let error = error {
                // HERE you can manage the error
                print(error)
                completion(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(.invalidData))
                return
            }
            
            // Serialize the data into an object
            do {
                let model = try JSONDecoder().decode(ValidServerResponse.self, from: responseData )
                print(model)
                completion(.success(model))
            } catch let error {
                print("Error during JSON serialization: \(error.localizedDescription)")
                completion(.failure(.custom(error.localizedDescription)))
            }
        })
        task.resume()
    }
}
