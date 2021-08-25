//
//  controlApp.swift
//  control
//
//  Created by Jesús Francisco Leyva Juárez on 24/03/21.
//

import SwiftUI
import Firebase

@main
struct controlApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    @State var index = 0
    var body: some Scene {
        WindowGroup {
            ContentView(index: $index)
        }
    }
}
