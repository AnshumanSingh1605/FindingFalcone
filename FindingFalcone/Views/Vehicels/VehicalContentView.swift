//
//  VehicalContentView.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 27/07/22.
//

import SwiftUI

struct VehicalContentView : View {
    
    var vehical : VehicleModel
    @Binding var selectedModel : VehicleModel?
    
    var body: some View {
        HStack {
            VStack {
                if vehical.name == selectedModel?.name {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "circle")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.leading)
            
            VStack(spacing : 0) {
                VehicalRowContent(title: "Name :", value: vehical.name)
                VehicalRowContent(title: "Max Distance :", value: String(vehical.max_distance))
                VehicalRowContent(title: "Speed :", value: String(vehical.speed))
                VehicalRowContent(title: "Total Number :", value: String(vehical.total_no))
            }
            .padding(.trailing)
            .frame(height: 90)
        }
        .addBorder(Color.accentColor, cornerRadius: 5)
        .padding(15)
        .onTapGesture {
            self.selectedModel = vehical
        }
    }
}

struct VehicalRowContent : View {
    
    let title : String
    let value : String
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .frame(width: 140, height: 20, alignment: .leading)
                Text(value)
                    .fontWeight(.semibold)
                    .frame(width: geometry.size.width - 140, height: 20, alignment: .leading)
            }
        }
    }
}
