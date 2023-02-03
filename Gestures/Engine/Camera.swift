//
//  Camera.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 29.01.2023.
//

import Foundation
import simd

// Main Camera Class

class Camera {
    
    var position: vector_float3
    var eulers: vector_float3
    
    var forwards: vector_float3
    var right: vector_float3
    var up: vector_float3
    var fix_forwards: vector_float3
    
    init(position: vector_float3, eulers: vector_float3) {
        
        self.position = position
        self.eulers = eulers
        
        self.forwards = [0.0, 0.0, 0.0]
        self.right = [0.0, 0.0, 0.0]
        self.up = [0.0, 0.0, 0.0]
        self.fix_forwards = [0, 0, 0]
    }
    
    func updateVectors() {
        
        forwards = [
            cos(eulers[2] * .pi / 180.0) * sin(eulers[1] * .pi / 180.0),
            sin(eulers[2] * .pi / 180.0) * sin(eulers[1] * .pi / 180.0),
            cos(eulers[1] * .pi / 180.0)
        ]
        
        var crx: Float = eulers[2] //yaw
        var cry: Float = eulers[1] //pitch
        var crz: Float = eulers[0] //roll
        
        crx = crx * .pi / 180.0
        cry = cry * .pi / 180.0
        crz = crz * .pi / 180.0
        
        
        
        fix_forwards = [
            sin(crx),
            sin(cry),
            cos(crx) * cos(cry)
        ]
        
        forwards = fix_forwards
        
        let globalUp: vector_float3 = [0.0, 1.0, 0.0]
        
        right = simd.normalize(simd.cross(globalUp, forwards))
        
        up = simd.normalize(simd.cross(forwards, right))
    }
}
