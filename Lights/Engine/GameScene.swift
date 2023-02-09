//
//  RenderScene.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 29.01.2023.
//

import Foundation
import SwiftUI

// Main Scene Class

class GameScene:ObservableObject {
    
    @Published var player: Entity
    @Published var actors: [Entity]
    
    var sun: Light
    var spotLight: Light
    
    init() {
//        player = Camera(
//            position: [0, 0.0, 0.0],
//            // roll, pitch, yaw
//            eulers: [0.0, 0.0, 0.0]
//        )
        self.player = Entity()
        self.actors = []
        
        self.sun = Light(color: [1.0, 1.0, 1.0])
        self.sun.declareDirectional(eulers: [0, 0, 0])
        self.sun.update()
        
        self.spotLight = Light(color: [0.0, 1.0, 0.0])
        self.spotLight.declareDirectional(eulers: [0, 0, 0])
        
        self.player.addCameraComponent(position: [0, 0, 0], eulers: [0, 0, 0])
        
        let newMesh = Entity()
        newMesh.addTransformComponent(position: [0, 0, 6.0], eulers: [0, 180.0, 0.0])
        actors.append(newMesh)
    }
    
    func update() {
        
        player.update()
        
        for act in actors {
            
            act.update()
            act.addRotation(rotaion: [0, 1.0, 0.0])
        }
        
        spotLight.update()
    }
    
    func spinCamera(offset: CGSize) {
        let dTheta: Float = Float(offset.width)
        let dPhi: Float = Float(offset.height)
        
        player.eulers!.y += 0.005 * dPhi
        player.eulers!.z -= 0.005 * dTheta
        
        //player.updateVectors()
    }
}
