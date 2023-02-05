//
//  RenderScene.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 29.01.2023.
//

import Foundation
import SwiftUI

// Main Scene Class

class RenderScene:ObservableObject {
    
    @Published var player: Camera
    @Published var actors: [TransformComponent]
    
    init() {
        player = Camera(
            position: [0, 0.0, 0.0],
            // roll, pitch, yaw
            eulers: [0.0, 0.0, 0.0]
        )
        
        actors = [
            TransformComponent(
                position: [0.0, 0.0, 7.0],
                eulers: [0.0, 0.0, 0.0]
            )
        ]
    }
    
    func update() {
        
        player.updateVectors()
        
        for act in actors {
            
            act.addRotation(rotaion: [0.0, 1.0, 0.0])
            
        }
        
    }
    
    func spinCamera(offset: CGSize) {
        let dTheta: Float = Float(offset.width)
        let dPhi: Float = Float(offset.height)
        
        player.eulers.y += 0.005 * dPhi
        player.eulers.z -= 0.005 * dTheta
        
        player.updateVectors()
    }
}
