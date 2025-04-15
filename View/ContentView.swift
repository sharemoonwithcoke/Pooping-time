
//
//  ContentView.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if userViewModel.isFirstLaunch {
                OnboardingView()
                    .environmentObject(userViewModel)
            } else {
                TabView(selection: $selectedTab) {
                    RecordView()
                        .environmentObject(userViewModel)
                        .environmentObject(DataManager.shared)
                        .tabItem {
                            Image(selectedTab == 0 ? "recordB" : "recordA")
                        }
                        .tag(0)
                    
                    CalendarView()
                        .environmentObject(userViewModel)
                        .environmentObject(DataManager.shared)
                        .tabItem {
                            Image(selectedTab == 1 ? "calendarB" : "calendarA")
                        }
                        .tag(1)
                    
                    StatisticsView(userGender: userViewModel.userProfile.gender)
                        .environmentObject(userViewModel)
                        .environmentObject(DataManager.shared)
                        .tabItem {
                            Image(selectedTab == 2 ? "statB" : "statA")
                        }
                        .tag(2)
                }
            }
        }
    }
    
}
