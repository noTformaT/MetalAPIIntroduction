//
//  SimpleComponent.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 29.01.2023.
//

import Foundation

// Transform component with position and eulers rotations

class Entity {
    var hasTransformComponent: Bool
    var position: simd_float3?
    var eulers: simd_float3?
    var model:matrix_float4x4?
    
    var hasCameraComponent:Bool
    var forwards: vector_float3?
    var right: vector_float3?
    var up: vector_float3?
    var view: matrix_float4x4?
    
    init() {
        self.hasCameraComponent = false
        self.hasTransformComponent =  false
    }
    
    func addTransformComponent(position: simd_float3, eulers: simd_float3) {
        self.hasTransformComponent = true
        self.position = position
        self.eulers = eulers
        self.model = Matrix44.create_identity()
    }
    
    func addCameraComponent(position: simd_float3, eulers: simd_float3) {
        self.hasCameraComponent = true
        self.position = position
        self.eulers = eulers
        self.view = Matrix44.create_identity()
    }
    
    func update() {
        if hasTransformComponent {
            model = Matrix44.create_from_rotation(eulers: eulers!)
            model = Matrix44.create_from_translation(translation: position!) * model!
        }
        
        if hasCameraComponent {
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
            
            let globalUp: vector_float3 = [0.0, 1.0, 0.0]
            
            right = simd.normalize(simd.cross(globalUp, forwards!))
            
            up = simd.normalize(simd.cross(forwards!, right!))
            
            view = Matrix44.create_lookat(eye: position!, target: position! + forwards!, up: up!)
        }
    }
    
//    func addRotation(rotaion: simd_float3)
//    {
//        self.eulers += rotaion
//
//        if self.eulers.x > 360 {
//            self.eulers.x -= 360
//        }
//
//        if self.eulers.z > 360 {
//            self.eulers.z -= 360
//        }
//
//        if self.eulers.y > 360 {
//            self.eulers.y -= 360
//        }
//    }
};
