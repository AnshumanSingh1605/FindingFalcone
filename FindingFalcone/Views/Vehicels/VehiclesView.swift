//
//  VehiclesView.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 25/07/22.
//

import SwiftUI

struct VehiclesView: View {

    @Environment(\.presentationMode) var presentation

    @Binding var vehicles : [VehicleModel]
    @Binding var planet : PlanetUIModel?
    @Binding var selectedPlanets : [PlanetUIModel]
    
    @State private var avalaibleVehicels : [VehicleModel] = []
    @State private var selectedVehical : VehicleModel?
    @State private var showAlert = false
    @State private var showLoader = false

    var body: some View {
        BaseView(isAPICallActive: $showLoader) {
            ZStack {
                Color.clear.edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if let _planet = planet {
                            Text(_planet.planet.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Distance :" + String(_planet.planet.distance))
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            if !avalaibleVehicels.isEmpty {
                                ForEach(avalaibleVehicels,id: \.name) { vehicle in
                                    VehicalContentView(vehical: vehicle, selectedModel: $selectedVehical)
                                }
                                
                                Button {
                                    if let selected = selectedVehical {
                                        planet?.vehicles = [selected.name]
                                        presentation.wrappedValue.dismiss()
                                    } else {
                                        self.showAlert = true
                                    }
                                } label: {
                                    Text("Confirm Vehicle")
                                }
                                .buttonStyle(BlueButton())
                                .padding(.vertical,40)
                            } else {
                                
                                Text("Oops! Sorry, \n There is no vehicle available for \(planet?.planet.name ?? "Planet")")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .padding(.top,80)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Vehicle")
        .showAlert(show: $showAlert, message: "Please a vehicle for \(planet?.planet.name ?? "Planet")") { }
        .onAppear() {
            loadAvailableData()
        }
    }
    
    private func loadAvailableData() {
        
        var arrDevices : [VehicleModel] = []
        
        // already selected vehicle by distance......
        if let planet = planet {
            let distance = planet.planet.distance
            arrDevices = vehicles.filter({ distance <= $0.max_distance })
        }
        
        arrDevices = fetchAvailableVehicels(vehicles: arrDevices)
        
        // highlight the already selected vehicle..
        if let device = planet?.vehicles?.first {
            self.selectedVehical = vehicles.filter({ $0.name == device }).first
        }
        
        self.avalaibleVehicels = arrDevices
    }

    private func fetchAvailableVehicels(vehicles : [VehicleModel]) -> [VehicleModel]{
        // arr devices contains all available vehicles present within the range of planet...
        // if within range, then validate... if already selected for other planet option
        // if yes, then reduce the count of the total_no of count.
        // if no, then present the data as it is...
        var arrDevices = vehicles
        var alreadySelectedVehicleForAnotherPlanet : [String] = []
        
        for _planet in selectedPlanets {
            if _planet != planet {
                // if planet is not same to current selected planet.
                // if vehicle is selected for that planet...
                if let vehicle = _planet.vehicles?.first {
                    alreadySelectedVehicleForAnotherPlanet.append(vehicle)
                }
            }
        }
        
        // create a dictionary from alreadySelected array with vehical name as key and number of elements as its count.

        let dictionaryOfVehicalAndItsCount = createDictionaryWithCount(alreadySelectedVehicleForAnotherPlanet)
        arrDevices = arrDevices.map({ vehical in
//            if alreadySelectedVehicleForAnotherPlanet.contains(where: { $0 == vehical.name }) {
//                // already selected by the planet
//                return VehicleModel(name: vehical.name, total_no: vehical.total_no - 1, max_distance: vehical.max_distance, speed: vehical.speed)
//            }
//
//            return vehical
            if let vehicleAlreadySelectedCount = dictionaryOfVehicalAndItsCount[vehical.name.lowercased()] {
                // this means vehical key already present in the dictionary
                return VehicleModel(name: vehical.name, total_no: vehical.total_no - vehicleAlreadySelectedCount,
                                    max_distance: vehical.max_distance, speed: vehical.speed)
            } else {
                return vehical
            }
        })
        
        return arrDevices.filter({ $0.total_no > 0 })
    }
    
    
    private func createDictionaryWithCount(_ array : [String]) -> [String : Int] {
        var dict : [String : Int] = [:]
        for item in array {
            var count = 1
            if let value = dict[item.lowercased()] {
                count += value
            }
            dict[item.lowercased()] = count
        }
        return dict
    }
}
