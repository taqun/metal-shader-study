//
//  ViewController.swift
//  MetalShaderStudy
//
//  Created by taqun on 2020/05/02.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    private var renderer: Renderer?;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let metalView = MTKView(frame: self.view.frame);
        self.view.addSubview(metalView);
        
        renderer = Renderer(view: metalView);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.changeNextShader();
    }
}

