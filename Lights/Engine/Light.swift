//
//  Light.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 09.02.2023.
//

import Foundation

class Light {
    
    var type: LightType
    var position: vector_float3?
    var eulers: vector_float3?
    var forwards: vector_float3?
    var color: vector_float3
    var t:Float?
    var rotationCenter: vector_float3?
    var pathRadius: Float?
    var pathPhi: Float?
    var angularVelocity: Float?
    
    init(color: vector_float3) {
        self.type = UNDEFINED_LIGHT
        self.color = color
    }
    
    func declareDirectional(eulers: vector_float3) {
        self.type = DIRECTIONAL_LIGHT
        self.eulers = eulers
    }
    
    func declareSpotlight(position: vector_float3, eulers: vector_float3) {
        self.type = SPOT_LIGHT
        self.position = position
        self.eulers = eulers
        self.t = 0.0
    }
    
    func declatePoinLight(rotationCenter: vector_float3,
                          pathRadius: Float,
                          pathPhi: Float,
                          angularVelocity: Float) {
        self.type = POINT_LIGHT
        self.rotationCenter = rotationCenter
        self.pathRadius = pathRadius
        self.pathPhi = pathPhi
        self.angularVelocity = angularVelocity
        self.t = 0.0
        self.position = rotationCenter
    }
    
    func update() {
        if type == DIRECTIONAL_LIGHT {
            var crx: Float = eulers![2] //yaw
            var cry: Float = eulers![1] //pitch
            var crz: Float = eulers![0] //roll
            
            crx = crx * .pi / 180.0
            cry = cry * .pi / 180.0
            crz = crz * .pi / 180.0
            
            forwards = [
                sin(crx),
                sin(cry),
                cos(crx) * cos(cry)
            ]
        } else if type == SPOT_LIGHT {
            
        } else if type == POINT_LIGHT {
            
        }
    }
}
