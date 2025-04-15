//
//  UseViewModel.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//
import Foundation
import Combine

class UserViewModel: ObservableObject {
   @Published var userProfile: UserProfile = .empty
   @Published var isFirstLaunch: Bool = true
   
   init() {
       
       self.isFirstLaunch = true
       
       
       loadUserProfile()
       
       
       DispatchQueue.main.async {
           if let data = UserDefaults.standard.data(forKey: "userProfile"),
              let _ = try? JSONDecoder().decode(UserProfile.self, from: data) {
               self.isFirstLaunch = false
           }
       }
   }
   
   func saveUserProfile() {
       do {
           let data = try JSONEncoder().encode(userProfile)
           UserDefaults.standard.set(data, forKey: "userProfile")
           isFirstLaunch = false
       } catch {
           print("Failed to save user profile: \(error)")
       }
   }
   
   private func loadUserProfile() {
       guard let data = UserDefaults.standard.data(forKey: "userProfile") else {
           return
       }
       
       do {
           userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
       } catch {
           print("Failed to load user profile: \(error)")
       }
   }
}
