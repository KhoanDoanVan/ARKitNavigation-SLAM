//
//  ARVC+ARSessionDelegate.swift
//  ARKitNavigation-SLAM
//
//  Created by Đoàn Văn Khoan on 17/3/25.
//


import ARKit
import Vision
import RealityFoundation

// MARK: - DELEGATE AR View
extension ARViewController: ARSessionDelegate {
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                
                let isHorizontal = planeAnchor.alignment == .horizontal
                print("Detected \(isHorizontal ? "Horizontal" : "Vertical") Plane")
                
                self.detectedPlanes.append(planeAnchor)
                
                updatePointsGrid()
                
            }
        }
        
    }
    
    func updatePointsGrid() {
        for plane in detectedPlanes {
            let isHorizontal = plane.alignment == .horizontal
            placeDotsOnPlane(plane, isHorizontal: isHorizontal)
        }
    }
    
    /// Place Dots on plane
    func placeDotsOnPlane(_ planeAnchor: ARPlaneAnchor, isHorizontal: Bool) {
        
        let center = planeAnchor.center
        let width = planeAnchor.planeExtent.width
        let height = planeAnchor.planeExtent.height
        
        let dotSize: Float = 0.02
        let rows = Int(height / dotSize)
        let cols = Int(width / dotSize)
        
        for i in 0..<rows {
            for j in 0..<cols {
                let x = center.x + (Float(j) * dotSize) - width / 2
                let y = isHorizontal ? 0 : (center.y + (Float(i) * dotSize) - height / 2)
                let z = isHorizontal ? (center.z + (Float(i) * dotSize) - height / 2) : 0
                
                createDot(at: SIMD3<Float>(x, y, z))
            }
        }
        
    }
    
    /// Create Dot
    func createDot(at position: SIMD3<Float>) {
        
        let dot = ModelEntity(mesh: .generateSphere(radius: 0.002))
        dot.model?.materials = [SimpleMaterial(color: .green, isMetallic: false)]
        
        let anchor = AnchorEntity(world: position)
        anchor.addChild(dot)
        
        arView.scene.addAnchor(anchor)
    }
    
}
