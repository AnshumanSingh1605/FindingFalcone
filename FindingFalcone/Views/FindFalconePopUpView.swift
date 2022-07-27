//
//  FindFalconePopUpView.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 26/07/22.
//

import SwiftUI

struct FindFalconePopUpView: View {
    
    @Binding var response : FindRequestResponseUIModel?
    var didPressedStartOver : () -> Void = {}
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("Finding Falcone !")
                        .font(.largeTitle)
        
                    
                    if let status = response?.status {
                        Text((status.capitalized) + "!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(status.lowercased() == "success" ? .green : .red)
                            .padding(.vertical,10)
                        
                        Text(status.lowercased() == "success" ?
                             "Congratulation on finding Falcone. King Shah is mighty pleased." :
                            "Failed to find Falcone. King Shah is mighty displeased")
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                        
                            
                        if let planet = response?.planet {
                            Text("Planet Found : \(planet)")
                                .fontWeight(.semibold)
                        }
                        
                        if let time = response?.timeTaken {
                            Text("Time Taken : \(time)")
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Button {
                        self.didPressedStartOver()
                    } label: {
                        Text("Start Over")
                    }
                    .buttonStyle(BlueButton())
                    .padding(.vertical)
                }
                .padding()
                .background(Color.white.shadow(color: Color.black.opacity(0.6), radius: 5, x: 5, y: 0)
)
                .addBorder(Color.accentColor, cornerRadius: 5)
                .padding()
        }
    }
}

struct FindFalconePopUpView_Previews: PreviewProvider {
    static var previews: some View {
        FindFalconePopUpView(response: .constant(FindRequestResponseUIModel(planet: "Jebing", status: "failure", timeTaken: nil)))
    }
}
