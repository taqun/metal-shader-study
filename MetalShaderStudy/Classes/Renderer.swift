//
//  Renderer.swift
//  MetalShaderStudy
//
//  Created by taqun on 2020/05/02.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    
    private var view: MTKView?;
    
    private var device: MTLDevice?
    private var commandQueue: MTLCommandQueue?
    private var pipelineState: MTLRenderPipelineState?;
    
    private var time: Float = 0;
    private var aspectRatio: Float = 1;
    private var shaderIndex: Int = 0;
        
    let vertexData: [Float] = [
        -1,  1, 0, 0,
        -1, -1, 0, 1,
         1, -1, 1, 1,
         1, -1, 1, 1,
         1,  1, 1, 0,
        -1,  1, 0, 0
    ];
    private var vertexBuffer: MTLBuffer?;
    
    init(view: MTKView) {
        super.init();
        
        self.view = view;
        self.view?.delegate = self;
        
        self.device = MTLCreateSystemDefaultDevice();
        self.view?.device = self.device;
        
        aspectRatio = Float(view.frame.height / view.frame.width);
                
        commandQueue = device?.makeCommandQueue();
        
        self.buildPipeline();
        
        vertexBuffer = device?.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Float>.size, options: [.storageModeShared]);
    }
    
    private func buildPipeline() {
        let library = device?.makeDefaultLibrary();
        
        let vertexShader = library?.makeFunction(name: "vertex_function");
        let fragmentShader = library?.makeFunction(name: "fragment_function");

        let vertexDescriptor = MTLVertexDescriptor()

        let pipelineDescriptor = MTLRenderPipelineDescriptor();
        pipelineDescriptor.vertexFunction = vertexShader;
        pipelineDescriptor.fragmentFunction = fragmentShader;
        pipelineDescriptor.vertexDescriptor = vertexDescriptor;
        pipelineDescriptor.colorAttachments[0].pixelFormat = view!.colorPixelFormat;
        
        do {
            pipelineState = try device?.makeRenderPipelineState(descriptor: pipelineDescriptor);
        } catch {
            
        }
    }
    
    func changeNextShader() {
        shaderIndex += 1;
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }
    
    func draw(in view: MTKView) {
        time += 1.0 / Float(view.preferredFramesPerSecond);
        
        if let drawable = self.view?.currentDrawable, let renderPassDescriptor = self.view?.currentRenderPassDescriptor {
            let buffer = commandQueue?.makeCommandBuffer();

            let encoder = buffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor);
            encoder?.setRenderPipelineState(pipelineState!);
            encoder?.setVertexBuffer(vertexBuffer!, offset: 0, index: 0);
            encoder?.setFragmentBytes(&time, length: MemoryLayout<Float>.size, index: 0);
            encoder?.setFragmentBytes(&aspectRatio, length: MemoryLayout<Float>.size, index: 1);
            encoder?.setFragmentBytes(&shaderIndex, length: MemoryLayout<Int>.size, index: 2);
            encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6);
            encoder?.endEncoding();
            buffer?.present(drawable);
            buffer?.commit();
        }
    }
}

