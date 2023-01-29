//
//  Renderer.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 27.01.2023.
//
 
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    
    // Render include:
    // * Metal Device
    // * Metal Command Queue,
    // * Metal Pipeline State
    // * Metal Vertex Buffer
    
    var parent: ContentView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    let pipelineState: MTLRenderPipelineState
    var scene: RenderScene
    let mesh: TriangleMesh
    
    init (_ parent: ContentView) {
        self.parent = parent
        
        // Create Metal Device
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        
        // Create Metal Command Queue
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        
        // Create Metal Pipeline Descriptor
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()                                      // get Metal library from .metal file
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")     // get vertex shader function
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader") // get fragment shader function
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm                    // use pixel format
        
        // Create Metal Pipeline State
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Fail to create pipeline state")
        }
        
        // Create triangle Mesh
        mesh = TriangleMesh(metalDevice: metalDevice)
        
        // Create Render Scene
        scene = RenderScene()
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        // update scene
        
        scene.update()
        
        guard let drawable = view.currentDrawable else {
            return
        }
        
        // Create Metal Command Buffer from Metal Command Queue
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        
        // Create Render Pass Descriptor
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1.0) // set clear clor
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear                                                   // set load action - clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store                                                  // set store action - store
        
        // Make Metal Render Command Encoder
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        
        // Make Camera Parameters
        var cameraData: CameraParameters = CameraParameters()
        cameraData.view = Matrix44.create_lookat(
            eye: scene.player.position,
            target: scene.player.position + scene.player.forwards,
            up: scene.player.up
        )
        
        cameraData.projection = Matrix44.create_perspective_projection(
            fovy: 45,
            aspect: 800.0/600.0,
            near: 0.1,
            far: 20
        )
        
        renderEncoder?.setVertexBytes(&cameraData, length: MemoryLayout<CameraParameters>.stride, index: 2)
        
        for triangle in scene.triangles {
            var modelMatrix: matrix_float4x4 = Matrix44.create_from_rotation(eulers: triangle.eulers)
            modelMatrix = Matrix44.create_from_translation(translation: triangle.position) * modelMatrix
            
            
            renderEncoder?.setVertexBytes(&modelMatrix, length: MemoryLayout<matrix_float4x4>.stride, index: 1)
            
            renderEncoder?.setRenderPipelineState(pipelineState)
            renderEncoder?.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
            renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        }
        
        // Set present mode and end encoding
        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        
        // Commit Commands
        commandBuffer?.commit()
    }
}
