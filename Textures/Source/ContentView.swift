//
//  ContentView.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 27.01.2023.
//

import SwiftUI
import MetalKit

struct ContentView: UIViewRepresentable {
    
    @EnvironmentObject var gameScene: RenderScene
    
    func makeCoordinator() -> Renderer {
        Renderer(self, scene: gameScene)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ContentView>) -> some UIView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true

        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }

        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        mtkView.isPaused = false
        mtkView.depthStencilPixelFormat = .depth32Float

        return mtkView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
