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
}


typealias ValidServerResponse<T : Codable> =  T
typealias WebResponse<ValidServerResponse> = (Result<ValidServerResponse, APIErrors>) -> Void


//MARK: - Common Properties and Configurations
extension Endpoints {
    
    var baseUrl : String {
        return "https://jsonplaceholder.typicode.com/posts"//"https://findfalcone.herokuapp.com/"
    }
    
    var authenticationToken : String? {
        return nil
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
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            // Check the response
            debugPrint(response)
            
            // Check if an error occured
            if let error = error {
                // HERE you can manage the error
                print(error)
                completion(.failure(.custom(error)))
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
                completion(.failure(.invalidResponse))
            }
        })
        task.resume()
    }
}
