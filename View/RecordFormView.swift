//
//  RecordFormView.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//

import SwiftUI
import Foundation


enum RecordStep {
   case stoolColor
   case bristolType
   case stoolFeeling
   case urineCheck
   case urineColor
   case urineVolume
   case periodCheck
   case periodFlow
   case complete
}

struct HandDrawnButton: ButtonStyle {
   func makeBody(configuration: Configuration) -> some View {
       configuration.label
           .padding(.vertical, 8)
           .padding(.horizontal, 15)
           .background(
               RoundedRectangle(cornerRadius: 8)
                   .stroke(Color.black, style: StrokeStyle(
                       lineWidth: 1,
                       lineCap: .round,
                       lineJoin: .round,
                       dash: [4, 0],
                       dashPhase: 0
                   ))
           )
           .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
   }
}

// task track
struct ProgressIndicator: View {
   let currentStep: RecordStep
   
   var body: some View {
       HStack(spacing: 4) {
           ForEach(0..<totalSteps, id: \.self) { index in
               Circle()
                   .fill(index <= currentStepNumber ? Color.blue : Color.gray)
                   .frame(width: 6, height: 6)
               if index < totalSteps - 1 {
                   Rectangle()
                       .fill(index < currentStepNumber ? Color.blue : Color.gray)
                       .frame(width: 12, height: 1)
               }
           }
       }
       .padding(.horizontal, 10)
       .frame(maxWidth: 300)
   }
   
   private var currentStepNumber: Int {
       switch currentStep {
       case .stoolColor: return 0
       case .bristolType: return 1
       case .stoolFeeling: return 2
       case .urineCheck: return 3
       case .urineColor: return 4
       case .urineVolume: return 5
       case .periodCheck: return 6
       case .periodFlow: return 7
       case .complete: return 8
       }
   }
   
   private var totalSteps: Int { 9 }
}

// optionbutton view
struct OptionButton: View {
   let option: String
   let isSelected: Bool
   let onSelect: (String) -> Void
   let iconName: String?
   
   var body: some View {
       Button(action: { onSelect(option) }) {
           HStack {
               if let iconName = iconName {
                   Image(iconName)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 40, height: 40)
               }
               
               Text(option)
                   .font(.caption)
                   .lineLimit(2)
                   .multilineTextAlignment(.leading)
               Spacer()
               Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                   .foregroundColor(isSelected ? .blue : .gray)
                   .imageScale(.small)
                   .font(.caption)
           }
           .padding(.vertical, 6)
           .padding(.horizontal, 10)
           .frame(maxWidth: .infinity, minHeight: 30)
           .background(Color.white)
           .cornerRadius(6)
           .overlay(
               RoundedRectangle(cornerRadius: 6)
                   .stroke(Color.black, style: StrokeStyle(
                       lineWidth: 1,
                       lineCap: .round,
                       lineJoin: .round,
                       dash: [4, 0],
                       dashPhase: 0
                   ))
           )
       }
       .buttonStyle(PlainButtonStyle())
   }
}

// list
struct OptionsListView: View {
   let options: [String]
   let selectedOption: String?
   let onSelect: (String) -> Void
   let icons: [String: String]?
   
   var body: some View {
       VStack(spacing: 10) {
           ForEach(options, id: \.self) { option in
               OptionButton(
                   option: option,
                   isSelected: option == selectedOption,
                   onSelect: onSelect,
                   iconName: icons?[option]
               )
           }
       }
   }
}

// question
struct QuestionView: View {
   let question: String
   let options: [String]
   let selectedOption: String?
   let onSelect: (String) -> Void
   let onNext: () -> Void
   let icons: [String: String]?
   
   var body: some View {
       VStack(spacing: 10) {
           Text(question)
               .font(.callout)
               .padding(.vertical, 8)
               .multilineTextAlignment(.center)
           
           OptionsListView(
               options: options,
               selectedOption: selectedOption,
               onSelect: onSelect,
               icons: icons
           )
           .padding(.horizontal, 10)
           
           if selectedOption != nil {
               Button("Next step", action: onNext)
                   .buttonStyle(HandDrawnButton())
                   .padding(.vertical, 8)
           }
       }
       .frame(width: 300)
       .frame(minHeight: 360)
       .handDrawnFrame()
   }
}

// check-if finish
struct CheckView: View {
   let title: String
   let onYes: () -> Void
   let onNo: () -> Void
   
   var body: some View {
       VStack(spacing: 20) {
           Text(title)
               .font(.callout)
               .padding()
               .multilineTextAlignment(.center)
           
           HStack(spacing: 30) {
               Button("Yes") {
                   onYes()
               }
               .buttonStyle(HandDrawnButton())
               
               Button("No") {
                   onNo()
               }
               .buttonStyle(HandDrawnButton())
           }
       }
       .padding()
       .frame(width: 600)
       .frame(minHeight: 400)
       .handDrawnFrame()
   }
}

struct CompleteView: View {
   let onSave: () -> Void
   
   var body: some View {
       VStack(spacing: 30) {
           Image(systemName: "checkmark.circle.fill")
               .font(.system(size: 40))
               .foregroundColor(.green)
           
           Text("Done!")
               .font(.callout)
           
           Button("Save", action: onSave)
               .buttonStyle(HandDrawnButton())
       }
       .padding()
       .frame(width: 400)
       .frame(minHeight: 400)
       .handDrawnFrame()
   }
}

struct RecordFormView: View {
   @Environment(\.dismiss) var dismiss
   @EnvironmentObject var userViewModel: UserViewModel
   @EnvironmentObject var dataManager: DataManager
   
   let recordDuration: TimeInterval
   @State private var currentStep: RecordStep = .stoolColor
   
   // form type
   @State private var selectedType: Record.BristolType = .type4
   @State private var selectedColor: Record.StoolColor = .brown
   @State private var selectedFeeling: Record.Feeling = .normal
   @State private var hasUrination = false
   @State private var urineColor: Record.UrineColor = .lightYellow
   @State private var urineVolume: Record.UrineVolume = .normal
   @State private var hasPeriod = false
   @State private var periodFlow: Record.PeriodFlow = .medium
   
   @State private var showColorAlert = false
   @State private var showHealthWarning = false
   @State private var showColorAdvice = false
   @State private var pendingRecord: Record? = nil
   
   
   private func getStoolIconName(_ color: Record.StoolColor) -> String {
       switch color {
       case .brown: return "stool_brown_icon"
       case .darkBrown: return "stool_darkbrown_icon"
       case .black: return "stool_black_icon"
       case .green: return "stool_green_icon"
       case .yellow: return "stool_yellow_icon"
       case .red: return "stool_red_icon"
       case .white: return "stool_white_icon"
       }
   }
   
   private func getUrineIconName(_ color: Record.UrineColor) -> String {
       switch color {
       case .clear: return "urine_clear_icon"
       case .lightYellow: return "urine_lightyellow_icon"
       case .darkYellow: return "urine_darkyellow_icon"
       case .red: return "urine_red_icon"
       }
   }
   
   private func getPeriodFlowIconName(_ flow: Record.PeriodFlow) -> String {
       switch flow {
       case .light: return "period_light_icon"
       case .medium: return "period_medium_icon"
       case .heavy: return "period_heavy_icon"
       }
   }
   
   var body: some View {
       NavigationView {
           VStack {
               ProgressIndicator(currentStep: currentStep)
                   .padding()
               
               Spacer()
               
               switch currentStep {
               case .stoolColor:
                   QuestionView(
                       question: "What color does your poop look?",
                       options: Record.StoolColor.allCases.map { $0.rawValue },
                       selectedOption: selectedColor.rawValue,
                       onSelect: { colorStr in
                           selectedColor = Record.StoolColor.allCases.first { $0.rawValue == colorStr }!
                       },
                       onNext: { currentStep = .bristolType },
                       icons: Dictionary(uniqueKeysWithValues: Record.StoolColor.allCases.map {
                           ($0.rawValue, getStoolIconName($0))
                       })
                   )
                   
               case .bristolType:
                   QuestionView(
                       question: "and what type the poop look?",
                       options: Record.BristolType.allCases.map { $0.description },
                       selectedOption: selectedType.description,
                       onSelect: { typeStr in
                           selectedType = Record.BristolType.allCases.first { $0.description == typeStr }!
                       },
                       onNext: { currentStep = .stoolFeeling },
                       icons: nil
                   )
                   
               case .stoolFeeling:
                   QuestionView(
                       question: "how do you feel？",
                       options: Record.Feeling.allCases.map { $0.rawValue },
                       selectedOption: selectedFeeling.rawValue,
                       onSelect: { feelingStr in
                           selectedFeeling = Record.Feeling.allCases.first { $0.rawValue == feelingStr }!
                       },
                       onNext: { currentStep = .urineCheck },
                       icons: nil
                   )
                   
               case .urineCheck:
                   CheckView(
                       title: "do you pee?",
                       onYes: {
                           hasUrination = true
                           currentStep = .urineColor
                       },
                       onNo: {
                           hasUrination = false
                           currentStep = userViewModel.userProfile.gender == .female ? .periodCheck : .complete
                       }
                   )
                   
               case .urineColor:
                   QuestionView(
                       question: "what color is your pee?",
                       options: Record.UrineColor.allCases.map { $0.rawValue },
                       selectedOption: urineColor.rawValue,
                       onSelect: { colorStr in
                           urineColor = Record.UrineColor.allCases.first { $0.rawValue == colorStr }!
                       },
                       onNext: { currentStep = .urineVolume },
                       icons: Dictionary(uniqueKeysWithValues: Record.UrineColor.allCases.map {
                           ($0.rawValue, getUrineIconName($0))
                       })
                   )
                   
               case .urineVolume:
                   QuestionView(
                       question: "Is it a lot?",
                       options: Record.UrineVolume.allCases.map { $0.rawValue },
                       selectedOption: urineVolume.rawValue,
                       onSelect: { volumeStr in
                           urineVolume = Record.UrineVolume.allCases.first { $0.rawValue == volumeStr }!
                       },
                       onNext: { currentStep = userViewModel.userProfile.gender == .female ? .periodCheck : .complete },
                       icons: nil
                   )
                   
               case .periodCheck:
                   CheckView(
                       title: "Are you in your period?？",
                       onYes: {
                           hasPeriod = true
                           currentStep = .periodFlow
                       },
                       onNo: {
                           hasPeriod = false
                           currentStep = .complete
                       }
                   )
                   
               case .periodFlow:
                   QuestionView(
                       question: "Is it much?",
                       options: Record.PeriodFlow.allCases.map { $0.rawValue },
                       selectedOption: periodFlow.rawValue,
                       onSelect: { flowStr in
                           periodFlow = Record.PeriodFlow.allCases.first { $0.rawValue == flowStr }!
                       },
                       onNext: { currentStep = .complete },
                       icons: Dictionary(uniqueKeysWithValues: Record.PeriodFlow.allCases.map {
                           ($0.rawValue, getPeriodFlowIconName($0))
                       })
                   )
                   
               case .complete:
                   CompleteView(onSave: handleSaveRecord)
               }
               
               Spacer()
           }
           .navigationTitle(stepTitle)
           #if os(iOS)
           .navigationBarTitleDisplayMode(.inline)
           #endif
           .toolbar {
               #if os(iOS)
               ToolbarItem(placement: .cancellationAction) {
                   Button("cancle") {
                       dismiss()
                   }
               }
               #else
               ToolbarItem(placement: .automatic) {
                   Button("cancle") {
                       dismiss()
                   }
               }
               #endif
           }
           .alert("confirmed", isPresented: $showColorAlert) {
               Button("YES") {
                   showColorAdvice = true
               }
               Button("NO", role: .destructive) {
                   showHealthWarning = true
               }
           } message: {
               Text("Have you recently eaten food with coloring? (including natural colorings such as brightly colored fruits)")
           }
           .alert("reminder", isPresented: $showColorAdvice) {
               Button("Got it!") {
                   saveRecordAndDismiss()
               }
           } message: {
               Text("Possible pigmentation effects, try drinking more water, if symptoms persist seek help")
           }
                       .alert("⚠️ Warning", isPresented: $showHealthWarning) {
                           Button("OK") {
                               saveRecordAndDismiss()
                           }
                       } message: {
                           Text("This may be a precursor to illness, so seek professional help as soon as possible.")
                       }
                   }
                   .frame(width: 700, height: 500)
               }
               
               private var stepTitle: String {
                   switch currentStep {
                   case .stoolColor: return "Stool Color"
                   case .bristolType: return "Bristol Type"
                   case .stoolFeeling: return "Feeling"
                   case .urineCheck: return "Urination Check"
                   case .urineColor: return "Urine Color"
                   case .urineVolume: return "Urine Volume"
                   case .periodCheck: return "Period Check"
                   case .periodFlow: return "Period Flow"
                   case .complete: return "Complete"
                   }
               }
               
               private func handleSaveRecord() {
                   let record = Record(
                       date: Date(),
                       duration: recordDuration,
                       stoolCondition: Record.StoolCondition(
                           type: selectedType,
                           color: selectedColor,
                           feeling: selectedFeeling
                       ),
                       urineCondition: hasUrination ? Record.UrineCondition(
                           color: urineColor,
                           volume: urineVolume
                       ) : nil,
                       periodCondition: hasPeriod ? Record.PeriodCondition(
                           day: 1,
                           flow: periodFlow,
                           note: nil
                       ) : nil
                   )
                   
                   pendingRecord = record
                   
                
                   if selectedColor == .red || selectedColor == .black || selectedColor == .white ||
                       (hasUrination && urineColor == .red) {
                       showColorAlert = true
                   } else {
                       saveRecordAndDismiss()
                   }
               }
               
               private func saveRecordAndDismiss() {
                   if let record = pendingRecord {
                       dataManager.saveRecord(record)
                       dismiss()
                   }
               }
           }
