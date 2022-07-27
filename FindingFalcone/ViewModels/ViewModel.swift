//
//  ViewModel.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 24/07/22.
//

import Foundation
import Combine


class ViewModel : ObservableObject {
    
    @Published var planets : [PlanetModel] = []
    @Published var vehicles : [VehicleModel] = []
    @Published var isAPIActive = false
    @Published var apiError : APIErrors? 
    
    
    @Published var selectedPlanets : [PlanetUIModel] = [] {
        didSet {
            self.calculateEstimateTime()
        }
    }
    
    @Published var isGameStarted = false
    @Published var selectedPlanet : PlanetUIModel? {
        didSet {
            guard let selected = selectedPlanet else { return }
            if let index = selectedPlanets.firstIndex(where: { $0 == selected }) {
                DispatchQueue.main.async {
                    self.selectedPlanets[index] = selected
                }
            }
        }
    }

    @Published var showAlert = false
    @Published var findFalConeResponse : FindRequestResponseUIModel?
    
    @Published var estimatedTime : Int = 0
}

// MARK: - Handling Selection States
extension ViewModel {
    func startOver() {
        DispatchQueue.main.async {
            self.selectedPlanets = []
            self.isGameStarted = false
            self.selectedPlanet = nil
            self.findFalConeResponse = nil
        }
    }
    
    func findFalcone() {
        let (vehicles,isValid) = validateVehiclesSelectedForPlanets()
        if isValid {
            let planets = selectedPlanets.map({ $0.planet.name })
            showLoader()
            getToken { [weak self] tokenResponse in
                guard let token = tokenResponse?.token else {
                    DispatchQueue.main.async {
                        self?.apiError = .custom("Unable to fetch token")
                        self?.showAlert = true
                    }
                    self?.hideLoader()
                    return
                }
                let requestBody = FindRequestBodyModel(token: token, planets: planets, vehicles: vehicles)
                self?.findFalcone(body: requestBody) {
                    self?.hideLoader()
                }
            }
        } else {
            self.apiError = .invalidInput("Please select vehicle for all planets")
            self.showAlert = true
        }
    }
    
    // MARK: - Private Methods
    private func validateVehiclesSelectedForPlanets() -> ([String] ,Bool) {
        var arrVehicles : [String] = []
        for planet in selectedPlanets {
            guard let vehicle = planet.vehicles?.first else {
                return ([],false)
            }
            arrVehicles.append(vehicle)
        }
        return (arrVehicles,true)
    }
    
    private func calculateEstimateTime() {
        
        var estimateTime : Int = 0
        // traversing through selected planets
        for planet in selectedPlanets {
            if let vehicleName = planet.vehicles?.first , let vehicle = vehicles.first(where: { $0.name == vehicleName })  {
                // in case vehicle is selected......
                // speed
                let speed = vehicle.speed
                estimateTime += Int(planet.planet.distance / speed)
            }
        }
        
        self.estimatedTime = estimateTime
    }
}

extension ViewModel {
    // MARK: - Network calls and handlers
    func requestPlanets(completion : @escaping (Bool) -> Void) {
        sendRequest(api: .getPlanets) { [weak self] (model : [PlanetModel]?) in
            guard let model = model else {
                DispatchQueue.main.async {
                    self?.apiError = .invalidResponse
                    self?.showAlert = true
                }
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                self?.planets = model
            }
            completion(true)
        }
    }
    
    func requestVehicles(completion : @escaping () -> Void) {
        sendRequest(api: .getVehicles) { [weak self] (model : [VehicleModel]?) in
            guard let model = model else {
                DispatchQueue.main.async {
                    self?.apiError = .invalidResponse
                    self?.showAlert = true
                }
                completion()
                return
            }
            
            DispatchQueue.main.async {
                self?.vehicles = model
            }
            completion()
        }
    }
    
    private func findFalcone(body : FindRequestBodyModel, completion : @escaping () -> Void) {
        sendRequest(api: .find(body)) { [weak self] (response : FindRequestResponseUIModel?) in
            guard let model = response else {
                DispatchQueue.main.async {
                    self?.apiError = .invalidResponse
                    self?.showAlert = true
                }
                completion()
                return
            }
            
            let modelWithTime = FindRequestResponseUIModel(planet: model.planet, status: model.status, timeTaken: self?.estimatedTime)
            
            DispatchQueue.main.async {
                self?.findFalConeResponse = modelWithTime
            }
            
            completion()
        }
    }
    
    private func getToken(completion : @escaping (TokenModel?) -> Void) {
        sendRequest(api: .token) { [weak self] (response : TokenModel?) in
            guard let model = response else {
                DispatchQueue.main.async {
                    self?.apiError = .invalidResponse
                    self?.showAlert = true
                }
                completion(nil)
                return
            }
            completion(model)
        }
    }
}

// MARK: - CallableViewModelProtocol conforming.
extension ViewModel : CallableViewModel {
    
    private func showLoader() {
        DispatchQueue.main.async {
            self.isAPIActive = true
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.isAPIActive = false
        }
    }
    
    func loadData() {
    
        if !planets.isEmpty && !vehicles.isEmpty {
            return
        }
        
        showLoader()
        //first get planets....
        requestPlanets { [weak self] isPlatentsFetched in
            if isPlatentsFetched {
                //then requsted for get planets....
                DispatchQueue.global(qos: .background).async {
                    self?.requestVehicles { [weak self] in
                        self?.hideLoader()
                    }
                }
            } else {
                self?.hideLoader()
            }
        }
    }
    
    func sendRequest<T : Codable>(api : NetworkEndpoints, completion : @escaping(T?) -> Void) {
        api.request { [weak self] (response : Result<T,APIErrors>) in
            switch response {
            case let .success(model) :
                completion(model)
            case let .failure(error) :
                DispatchQueue.main.async {
                    self?.apiError = error
                    self?.showAlert = true
                }
                debugPrint(error.message)
                completion(nil)
            }
        }
    }
}
