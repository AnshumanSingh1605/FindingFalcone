//
//  PlanetsViewModel.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 25/07/22.
//

import Foundation
import Combine


final class PlanetsViewModel : ObservableObject {
    
    @Published var arrPlanets : [PlanetUIModel]
    @Published var alert : APIErrors?
    @Published var showAlert : Bool = false
    
    var planets : [PlanetModel] = []
    var selectedPlanetsCount  = 0
    
    init(planets : [PlanetModel]) {
        self.planets = planets
        self.arrPlanets = planets.map({ model in
            return PlanetUIModel(planet: model, vehicles: nil, isSelected: false)
        })
    }
    
    func handleTapAction(_ planet : PlanetUIModel) {
        debugPrint("planet tapped : \(planet.planet.name)")
        
        if planet.isSelected {
            // need to be deselected/removed
            if let index = arrPlanets.firstIndex(of: planet) {
                DispatchQueue.main.async {
                    self.arrPlanets[index].isSelected = false
                }
                selectedPlanetsCount -= 1
            }
        } else {
            // needs to be selected/added...
            if selectedPlanetsCount == 4 {
                // break...
                // no need to add..
                //show alert
                alert = .limitReached("Planets")
                showAlert = true
                return
            } else {
                // update selected state....
                if let index = arrPlanets.firstIndex(of: planet) {
                    DispatchQueue.main.async {
                        self.arrPlanets[index].isSelected = true
                    }
                    debugPrint("After adding \(arrPlanets[index])")
                    selectedPlanetsCount += 1
                }
            }
        }
    }
}
