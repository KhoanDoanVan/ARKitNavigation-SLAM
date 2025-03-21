//
//  ARViewContainer.swift
//  ARKitNavigation-SLAM
//
//  Created by Đoàn Văn Khoan on 17/3/25.
//

import ARKit
import RealityKit
import SwiftUI


struct ARViewContainer: UIViewControllerRepresentable {
    
    @Binding var showAR: Bool
    
    func makeUIViewController(context: Context) -> ARViewController {
        
        let arVC = ARViewController(showAR: $showAR)
        arVC.loadView()
        return arVC
        
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {}
    
}
