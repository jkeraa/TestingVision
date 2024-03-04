//
//  CigaretteBox.swift
//  TestingVIsion
//
//  Created by Jacques André Kerambrun on 28/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct CigaretteBox: View {
    @Environment (\.openImmersiveSpace)  var openImmersiveSpace
    @Environment (\.dismissImmersiveSpace)  var dismissImmersiveSpace
    @State var isDragging: Bool = false
    @State var rotation: Angle = .zero
    @State private var cigaretteBoxx = Entity()
    
    var body: some View {
        RealityView { content in
            if let cigaretteBox =   try? await Entity(named: "CigaretteBoxModel.usdz")
                {
                    cigaretteBox.position.y = 1
                cigaretteBox.position.z = -1
               // cigaretteEntity.transform.rotation = [0, -0.4, 0.3]
                //let radians = -90.0 * Float.pi / 180.0
                       //    cigaretteEntity.transform.rotation += simd_quatf(angle: radians, axis: SIMD3<Float>(0,1,0))
                    //cigaretteEntity.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 0, z: 0))
                    cigaretteBox.generateCollisionShapes(recursive: true)
                cigaretteBox.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                    cigaretteBox.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                        massProperties: .default,
                        material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.1),
                        mode: .dynamic
                    ))
                    cigaretteBox.components[PhysicsMotionComponent.self] = .init()
                cigaretteBoxx = cigaretteBox
                    content.add(cigaretteBoxx)
                
                }
        }
      .gesture(DragGesture()
        .targetedToEntity(cigaretteBoxx)
        .onChanged({value in
            cigaretteBoxx.position = value.convert(value.location3D, from: .local, to: cigaretteBoxx.parent!)
        })
      )
      .onTapGesture {
          Task {
              await dismissImmersiveSpace()
              await openImmersiveSpace(id: "Cigarette")
          }
      }
    }
}
