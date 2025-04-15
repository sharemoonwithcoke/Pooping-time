//
//  OnBoardingView.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var name: String = ""
    @State private var selectedGender: Gender = .notSpecified
    
    var body: some View {
        VStack(spacing: 30) {
            Text("welcome to Pooping-time")
                .font(.system(size: 28, weight: .bold))
                .padding()
                .handDrawnFrame()
            
            VStack(spacing: 20) {
                TextField("your name?", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 18))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 2)
                            .background(Color.white)
                    )
                
                HandDrawnDivider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("you are...")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Button(action: {
                                selectedGender = gender
                            }) {
                                Text(gender.rawValue)
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 5)
                            }
                            .buttonStyle(HandDrawnButtonStyle(color: selectedGender == gender ? .blue : .black))
                        }
                    }
                }
            }
            .padding()
            .handDrawnFrame()
            
            Button(action: {
                userViewModel.userProfile = UserProfile(name: name, gender: selectedGender)
                userViewModel.saveUserProfile()
            }) {
                Text("let's go")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
            }
            .buttonStyle(HandDrawnButtonStyle(color: name.isEmpty ? .gray : .black))
            .disabled(name.isEmpty)
        }
        .padding()
        .background(Color.white)
    }
}


