//
//  PlanetComponentView.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 25/07/22.
//

import Foundation
import SwiftUI

struct PlanetUIVehicleSection : View {
    
    let vehicles : [String]
    
    var body: some View {
        HStack {
            ForEach(vehicles,id: \.self) { vehicle in
                Text(vehicle)
                    .padding()
                    .addBorder(Color.accentColor, cornerRadius: 5)
                    .frame(height: 40, alignment: .center)
            }
        }
        .padding()
    }
}
