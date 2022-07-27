//
//  CallableViewModel.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 25/07/22.
//

import Foundation

protocol CallableViewModel {
    func loadData()
    func sendRequest<T : Codable>(api : NetworkEndpoints, completion : @escaping(T?) -> Void)
}
