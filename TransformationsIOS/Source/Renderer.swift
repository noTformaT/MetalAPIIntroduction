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
    let vertexBuffer: MTLBuffer
    
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
        
        // Create vertices
        let vertices = [
            Vertex(position: [-1, -1], color: [1, 0, 0, 1]),
            Vertex(position: [ 1, -1], color: [0, 1, 0, 1]),
            Vertex(position: [ 0, 1], color: [0, 0, 1, 1]),
        ]
        
        // Move vertices to vertex buffer
        vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        
        // Create Metal Pipeline State
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Fail to create pipeline state")
        }
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
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
        renderEncoder?.setRenderPipelineState(pipelineState)                                            // set Render Pipeline State
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)                               // set Vertex Buffer
        
        // Draw primitives - triangles
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        // Set present mode and end encoding
        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        
        // Commit Commands
        commandBuffer?.commit()
    }
}
