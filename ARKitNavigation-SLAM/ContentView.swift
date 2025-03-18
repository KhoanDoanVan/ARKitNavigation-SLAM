//
//  ContentView.swift
//  ARKitNavigation-SLAM
//
//  Created by Đoàn Văn Khoan on 17/3/25.
//

import SwiftUI
import ARKit

struct ContentView: View {
    
    @State private var showAR: Bool = false
    
    var body: some View {
        
        VStack {
            Button {
                self.showAR.toggle()
            } label: {
                Text("Let's scan the environment 🫵")
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 12)
            .background(Color.cyan)
        }
        .fullScreenCover(isPresented: $showAR) {
            ARViewContainer()
                .overlay {
                    VStack {
                        Text("Waiting")
                        ARCoachingOverlayView()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
