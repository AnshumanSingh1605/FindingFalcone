//
//  LandingView.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 24/07/22.
//

import SwiftUI

struct LandingView: View {

    @StateObject var viewModel = ViewModel()

    @State private var moveToVehicalDetails = false
    //@State private var selectedPlanet : PlanetUIModel?
    
    var body: some View {
        NavigationView {
            BaseView(isAPICallActive: $viewModel.isAPIActive) {
                ZStack {
                    
                    Color.clear.edgesIgnoringSafeArea(.all)
                    
                    NavigationLink(destination:
                                    VehiclesView(vehicles: $viewModel.vehicles,
                                                 planet: $viewModel.selectedPlanet,
                                                 selectedPlanets: $viewModel.selectedPlanets)//,
                                                 //allVehicels: viewModel.vehicles)
                                    , isActive: $moveToVehicalDetails) { EmptyView() }

                    
                    if !viewModel.selectedPlanets.isEmpty {
                        
                        ScrollView(showsIndicators: false) {
                            
                            VStack(spacing : -10) {
                                ForEach(viewModel.selectedPlanets,id: \.planet.name) { planet in
                                    PlanetView(model: .constant(planet))
                                        .onTapGesture {
                                            // move to vehicle detail screens.
                                            debugPrint("move to vehicle detail screens.")
                                            self.viewModel.selectedPlanet = planet
                                            self.moveToVehicalDetails = true
                                        }
                                }
                                
                                if viewModel.estimatedTime > 0 {
                                    Text("Time Taken : \(viewModel.estimatedTime)")
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                }
                                
                                Spacer()
                                
                                Button {
                                    self.viewModel.findFalcone()
                                } label: {
                                    Text("Find Falcone")
                                }
                                .buttonStyle(BlueButton())
                                .padding(.vertical,40)
                            }
                        }
                    } else {
                        
                        VStack {
                            Spacer()
                            
                            Text("Please select the planets to search falcone")
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            NavigationLink(destination: PlanetListView(planets: viewModel.planets, onDismiss: { arrModels in
                                self.viewModel.selectedPlanets = arrModels.filter({ $0.isSelected })
                            })) {
                                Text("Select Planets")
                            }
                            .buttonStyle(BlueButton())
                            .padding(.bottom,40)
                            .disabled(viewModel.planets.isEmpty)
                            .opacity(viewModel.planets.isEmpty ? 0 :  1)
                        }
                        
                    }
                    
                    ZStack {
                        FindFalconePopUpView(response: $viewModel.findFalConeResponse) {
                            self.viewModel.startOver()
                        }
                        .opacity(viewModel.findFalConeResponse == nil ? 0 : 1)
                        .offset(x: 0,
                                y: viewModel.findFalConeResponse == nil ? -UIScreen.main.bounds.height : 0)
                    }
                }
                .onAppear() {
                    viewModel.loadData()
                }
                .navigationTitle("Find Falcone")
            }
            .showAlert(show: $viewModel.showAlert,
                       message: viewModel.apiError?.message) {
                self.viewModel.apiError = nil
            }
        }
    }
}


