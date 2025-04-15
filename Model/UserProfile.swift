//
//  UserProfile.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//


import Foundation

struct UserProfile: Codable {
    var id: UUID = UUID()
    var name: String
    var gender: Gender
    
    static var empty: UserProfile {
        UserProfile(name: "", gender: .notSpecified)
    }
}

enum Gender: String, Codable, CaseIterable {
    case male = "male"
    case female = "female"
    case notSpecified = "no answer"
}
