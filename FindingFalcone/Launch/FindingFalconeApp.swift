//
//  FindingFalconeApp.swift
//  FindingFalcone
//
//  Created by Anshuman Singh on 21/07/22.
//

import SwiftUI

@main
struct FindingFalconeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LandingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
