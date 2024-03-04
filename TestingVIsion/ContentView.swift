//
//  ContentView.swift
//  TestingVIsion
//
//  Created by Jacques André Kerambrun on 26/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment (\.openWindow) private var openWindow
    @Environment (\.dismissWindow) private var dismissWindow
    @Environment (\.openImmersiveSpace)  var openImmersiveSpace
    @Environment (\.dismissImmersiveSpace)  var dismissImmersiveSpace
  
  
    var body: some View {
        VStack {
            Model3D(named: "CigaretteModel.usdz" )
                .padding(.bottom, 50)
        }
        .task {
            dismissWindow()
            dismissWindow(id: "Window")
            await openImmersiveSpace(id: "CigaretteBox")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
