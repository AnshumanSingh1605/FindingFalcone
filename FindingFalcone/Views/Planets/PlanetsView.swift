//
//  PlanetsView.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 25/07/22.
//

import SwiftUI


struct PlanetListView : View {
    
    @Environment(\.presentationMode) var presentation

    //var planets : [PlanetModel]
    @ObservedObject var vm : PlanetsViewModel
    
    var onDismiss : ([PlanetUIModel]) -> Void
    
    init(planets : [PlanetModel], onDismiss : @escaping ([PlanetUIModel]) -> Void) {
        self.vm = PlanetsViewModel(planets: planets)
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            
            Color.clear.edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing : -10) {
                    ForEach(vm.arrPlanets,id: \.planet.name) { planetUIModel in
                        PlanetView(model: .constant(planetUIModel))
                            .onTapGesture {
                                self.vm.handleTapAction(planetUIModel)
                            }
                    }

                    Button {
                        presentation.wrappedValue.dismiss()
                        onDismiss(vm.arrPlanets)
                    } label: {
                        Text("Confirm")
                    }
                    .buttonStyle(BlueButton())
                    .padding(.vertical,40)

                }
            }
        }
        .navigationTitle("Select Planets")
        .showAlert(show: $vm.showAlert, message: vm.alert?.message) {
            debugPrint("Warning dismissed")
            self.vm.alert = nil
            self.vm.showAlert = false
        }
    }
}

struct PlanetView : View {

    @Binding var model : PlanetUIModel

    var body: some View {
        ZStack {

            Color.clear

            VStack(spacing : 10) {
                Text(model.planet.name)
                    .fontWeight(.bold)
                Text(" Distance : \(model.planet.distance)")
                    .fontWeight(.semibold)
                if let vehicles = model.vehicles {
                    PlanetUIVehicleSection(vehicles: vehicles)
                        .frame(height: 60)
                }
            }
        }
        .padding()
        .background(model.isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
        .addBorder(Color.accentColor, cornerRadius: 5)
        .padding()
        .overlay(alignment: .trailing) {
            Image(systemName: "chevron.right")
                .font(.body)
                .padding(.trailing,20)
        }
    }
}
