//
//  TestingVIsionApp.swift
//  TestingVIsion
//
//  Created by Jacques André Kerambrun on 26/02/24.
//

import SwiftUI
@main
struct TestingVIsionApp: App {
        var body: some Scene {
            WindowGroup (id: "Window") {
                ContentView()
            }
            
            WindowGroup(id: "Volume") {
                Collision()
            }.windowStyle(.volumetric)
            
            ImmersiveSpace(id: "Cigarette") {
                Cigarette()
            }
            ImmersiveSpace(id: "CigaretteBox") {
                CigaretteBox()
            }
        }
    }
