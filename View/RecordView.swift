//
//  RecordView.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//

import SwiftUI
import Foundation

struct RecordView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel = RecordViewModel()
    
   
    @State private var currentImageIndex = 0
    let timer = Timer.publish(every: 0.9, on: .main, in: .common).autoconnect()
    
    
    let actionImages = ["bunny1", "bunny2", "bunny3", "bunny4", "bunny5", "bunny6"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                
                VStack(spacing: 10) {
                    Text("Hey，\(userViewModel.userProfile.name)")
                        .font(.system(size: 28, weight: .bold))
                    Text("Ready to Poo-Poo?")
                        .font(.system(size: 20))
                }
                .handDrawnFrame()
                
                HandDrawnDivider()
                
                
                Group {
                    if viewModel.isTracking {
                        
                        Image(actionImages[currentImageIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .onReceive(timer) { _ in
                                if viewModel.isTracking {
                                    currentImageIndex = (currentImageIndex + 1) % actionImages.count
                                }
                            }
                    } else {
                        Image(viewModel.showingForm ? "bunny7" : "bunny1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
                .padding()
                
                
                if viewModel.isTracking {
                    Text(viewModel.timeString)
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .handDrawnFrame()
                }
                
                
                Button(action: {
                    viewModel.toggleTracking()
                    if !viewModel.isTracking {
                        currentImageIndex = 0
                    }
                }) {
                    VStack {
                        Image(systemName: viewModel.isTracking ? "stop.fill" : "play.fill")
                            .font(.system(size: 40))
                        Text(viewModel.isTracking ? "End" : "Start")
                            .font(.headline)
                    }
                    .foregroundColor(.black)
                    .frame(width: 150, height: 150)
                }
                .buttonStyle(HandDrawnButtonStyle(color: viewModel.isTracking ? .red : .black))
                
                Spacer()
            }
            .padding(.top, 30)
            .background(Color.white)
            .sheet(isPresented: $viewModel.showingForm) {
                RecordFormView(recordDuration: viewModel.elapsedTime)
                    .environmentObject(userViewModel)
                    .environmentObject(DataManager.shared)
            }
        }
    }
}
