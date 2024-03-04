//
//  Cigarette.swift
//  TestingVIsion
//
//  Created by Jacques André Kerambrun on 27/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Cigarette: View {
    @State var isBursting = false
    @State var anchor = AnchorEntity()
    @State private var subscription: EventSubscription?
    @State var spark = ParticleEmitterComponent()
    @State var impact = ParticleEmitterComponent()
    @State var blow = ParticleEmitterComponent()
    let presets: [ParticleEmitterComponent] = [
        .Presets.fireworks,
        .Presets.impact,
        .Presets.sparks,
        .Presets.magic,
        .Presets.rain,
        .Presets.snow
    ]
    func particleSystem()  -> ParticleEmitterComponent {
        var particles = ParticleEmitterComponent()
        particles.timing = .repeating(warmUp: 0, emit: ParticleEmitterComponent.Timing.VariableDuration(duration: 100), idle: ParticleEmitterComponent.Timing.VariableDuration(duration: 0))
        particles.emitterShape = .point
        particles.mainEmitter.stretchFactor = 10
        particles.birthLocation = .surface
        particles.birthDirection = .local
        particles.emissionDirection = [0,0,1]
        particles.mainEmitter.vortexDirection = [6,6,6]
        particles.emitterShapeSize = [1,1,1] * 0.05
        particles.speed = 0.04
        
        particles.mainEmitter.birthRate = 100
        particles.mainEmitter.sortOrder = .decreasingAge
        particles.mainEmitter.size = 0.1
        particles.mainEmitter.acceleration = [0,0.25,0]
       particles.mainEmitter.sizeMultiplierAtEndOfLifespan = 0
        particles.mainEmitter.color = .evolving(start: .single(.black), end: .random(a: .white, b: .black))
        
        particles.mainEmitter.colorEvolutionPower = 0.1
        particles.mainEmitter.spreadingAngle = 0
        particles.mainEmitter.birthRate = 20
        
        particles.mainEmitter.lifeSpan = 3

        particles.mainEmitter.opacityCurve = .linearFadeIn
        return particles
        
    }
    func particleSystemFire()  -> ParticleEmitterComponent {
        var particles = ParticleEmitterComponent()
        particles.timing = .repeating(warmUp: 0, emit: ParticleEmitterComponent.Timing.VariableDuration(duration: 100), idle: ParticleEmitterComponent.Timing.VariableDuration(duration: 0))
        particles.emitterShape = .point
        particles.mainEmitter.stretchFactor = 10
        particles.birthLocation = .surface
        particles.birthDirection = .local
        particles.emissionDirection = [0,0,1]
        particles.mainEmitter.vortexDirection = [6,6,6]
        particles.emitterShapeSize = [1,1,1] * 0.05
        particles.speed = 0.04
        
        particles.mainEmitter.birthRate = 100
        
        particles.mainEmitter.size = 0.1
        particles.mainEmitter.acceleration = [0,0.25,0]
       particles.mainEmitter.sizeMultiplierAtEndOfLifespan = 0
        particles.mainEmitter.color = .evolving(start: .single(.red), end: .random(a: .white, b: .black))
        
        particles.mainEmitter.colorEvolutionPower = 0.1
        particles.mainEmitter.spreadingAngle = 0
        particles.mainEmitter.birthRate = 20
        
        particles.mainEmitter.lifeSpan = 1

        particles.mainEmitter.opacityCurve = .linearFadeIn
        particles.isEmitting = false
        
        particles.burstCount = 1000
        particles.burst()
        return particles
        
    }
    @State var isDragging: Bool = false
       @State var rotation: Angle = .zero
    @State private var cigarettee = Entity()
    @State private var lighter = Entity()
       

    var body: some View {
        RealityView { content in
            let floor = ModelEntity(mesh: .generatePlane(width: 50, depth: 50), materials: [OcclusionMaterial()])
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(
                massProperties: .default,
                mode: .static
            )
             content.add(floor)
            
            if let lighterEntity = try? await Entity(named: "LighterModel.usdz") {
                lighterEntity.scale = lighterEntity.scale/25
                lighterEntity.position.y = 2
                lighterEntity.position.z = -1
                lighterEntity.position.x = +0.5
                lighterEntity.generateCollisionShapes(recursive: true)
               // let radians = -90.0 * Float.pi / 180.0
                
                 spark = presets[2]
                spark.isEmitting = false
                
                spark.burstCount = 1000
               
                
            lighterEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                lighterEntity.components.set(spark)
                lighterEntity.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                    massProperties: .default,
                    material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.1),
                    mode: .static
                ))
            
         
                lighterEntity.components[PhysicsMotionComponent.self] = .init()
            lighter = lighterEntity
                lighter.name = "Lighter"
              
                content.add(lighter)
                let lighterr = content.entities.first?.findEntity(named: "Lighter")

                 subscription = content.subscribe(to: CollisionEvents.Began.self, on: lighterr) { collisionEvent in
                                        print(" Collision between \(collisionEvent.entityA.name) and \(collisionEvent.entityB.name)")
                     if((collisionEvent.entityA.name == "Cylinder_001" && collisionEvent.entityB.name == "lighttop_obj") || (collisionEvent.entityA.name == "lighttop_obj" && collisionEvent.entityB.name == "Cylinder_001")) {
                         spark.burst()
                         isBursting.toggle()
                         self.spark.burstCount = 200
                         
                         impact = presets[1]
                         impact.emitterShape = .point
                         impact.timing = .repeating(warmUp: 0, emit: ParticleEmitterComponent.Timing.VariableDuration(duration: 0), idle: ParticleEmitterComponent.Timing.VariableDuration(duration: 0))
                         impact.mainEmitter.lifeSpan = 10
                         impact.mainEmitter.birthRate = 100
                         impact.birthLocation = .surface
                         impact.birthDirection = .local
                         impact.mainEmitter.acceleration = [0, 0, 0.5]
                   
                  
                         lighter.components.set(spark)
                         cigarettee.components.set(impact)
                         
                     }
                }
            }
            
            anchor = AnchorEntity(.head)
            content.add(anchor)
              
            if let cigaretteEntity =   try? await Entity(named: "CigaretteModel.usdz")
                {
                cigaretteEntity.scale = cigaretteEntity.scale * 3
                    cigaretteEntity.position.y = 2
                cigaretteEntity.position.z = -1
               // cigaretteEntity.transform.rotation = [0, -0.4, 0.3]
                //let radians = -90.0 * Float.pi / 180.0
                       //    cigaretteEntity.transform.rotation += simd_quatf(angle: radians, axis: SIMD3<Float>(0,1,0))
                    //cigaretteEntity.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 0, z: 0))
                    cigaretteEntity.generateCollisionShapes(recursive: true)
                //cigaretteEntity.components.set(particleSystem())
                
                cigaretteEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                    cigaretteEntity.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                        massProperties: .default,
                        material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.1),
                        mode: .dynamic
                    ))
                
                
                    cigaretteEntity.components[PhysicsMotionComponent.self] = .init()
                cigarettee = cigaretteEntity                
                cigarettee.name = "Cigarette"
                content.add(cigarettee)
                }
            
            
           
        }
        .onChange(of: isBursting) {
            spark.burst()
            self.spark.burstCount = 200
      
            lighter.components.set(spark)

        }
        .onTapGesture {
 
            blow = presets[1]
           // blow.timing = .(warmUp: 0, emit: ParticleEmitterComponent.Timing.VariableDuration(duration: 0), idle: ParticleEmitterComponent.Timing.VariableDuration(duration: 0))
            /*
            blow.mainEmitter.birthRate = 0
            blow.burstCount = 2000
            blow.mainEmitter.lifeSpan = 10
            blow.emitterShape = .cone
            blow.mainEmitter.acceleration = [0, 1,0]
            blow.burst()
            anchor.components.set(blow)
       */
            spark.burst()
            isBursting.toggle()
            self.spark.burstCount = 200
      
            lighter.components.set(spark)
         
            
           
        }
          
      .gesture(DragGesture()
        .targetedToEntity(cigarettee)
        .onChanged({value in
            cigarettee.position = value.convert(value.location3D, from: .local, to: cigarettee.parent!)
        })
      )
      .gesture(DragGesture()
        .targetedToEntity(lighter)
        .onChanged({value in
            lighter.position = value.convert(value.location3D, from: .local, to: lighter.parent!)
        })
      )
      
        
    }
    var dragGesture: some Gesture {
        DragGesture()
        .targetedToAnyEntity()
        .onChanged { value in
            value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
            value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
        }
        .onEnded { value in
            value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
        }
    }
}
