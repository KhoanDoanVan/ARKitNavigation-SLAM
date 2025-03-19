//
//  ARViewController.swift
//  ARKitNavigation-SLAM
//
//  Created by Đoàn Văn Khoan on 17/3/25.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit
import UIKit

// MARK: - VC
class ARViewController: UIViewController {
    
    // MARK: - Properties
    public var arView: ARView!
    private var arCoachingView: ARCoachingOverlayView?
    
    public var detectedPlanes: [ARPlaneAnchor] = []
    @Binding var showAR: Bool

    private var btnFinishedScan: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Finish Scan", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = true
        
        return button
    }()
    
    
    init(showAR: Binding<Bool>) {
        _showAR = showAR // Gán giá trị Binding
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    /// Call before view did load
    override func loadView() {
        
        setupARView()
        setupARCoachingView()
        setupButtonFinish()
        
    }
    
    /// Setup AR View
    func setupARView() {
        self.arView = ARView(
            frame: .zero,
            cameraMode: .ar,
            automaticallyConfigureSession: false
        )
        self.arView.session.delegate = self /// Delegate
        view = arView
    }
    
    /// Setup AR Coaching View
    private func setupARCoachingView() {
        self.arCoachingView = ARCoachingOverlayView()
        self.arCoachingView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.arCoachingView?.session = self.arView.session
        self.arCoachingView?.goal = .anyPlane
        self.arCoachingView?.activatesAutomatically = true
        self.arCoachingView?.delegate = self /// Delegate
        
        /// Add Subview
        if let coachingView = self.arCoachingView {
            coachingView.frame = self.arView.bounds
            print("Add Coaching View")
            self.arView.addSubview(coachingView)
        }
    }
    
    private func setupButtonFinish() {
        arView.addSubview(self.btnFinishedScan)
        self.btnFinishedScan.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.btnFinishedScan.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.btnFinishedScan.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.btnFinishedScan.widthAnchor.constraint(equalToConstant: 150),
            self.btnFinishedScan.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        btnFinishedScan.addTarget(self, action: #selector(tapFinish), for: .touchUpInside)
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.stopSession()
    }
    
    // MARK: - Action
    @objc func tapFinish() {
        self.saveWorldMap()
        
    }
    
    // MARK: - Private
    private func saveWorldMap() {
        
        self.arView.session.getCurrentWorldMap { worldMap, error in
                        
            guard let worldMap else {
                print("Failed to get world map:\(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
                UserDefaults.standard.set(data, forKey: "savedWorldMap")
                print("WorldMap Saved Successfully!")
                
                self.stopSession()
                
                
            } catch {
                print("Failed to save the world map:\(error.localizedDescription)")
            }
        }
    }
}

extension ARViewController {
    
    func setup() {
        // debugLog("AR: ARVC: setup() was called.")
    }
    
    /// START SESSION
    private func startSession() {
        
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        configuration.isCollaborationEnabled = true
        
        self.arView.session.run(configuration, options: [.resetTracking])
        
    }
    
    /// STOP SESSION
    private func stopSession() {
        self.arView.session.pause()
        
        self.showAR = false
    }
}


