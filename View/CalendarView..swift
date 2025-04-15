import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @StateObject private var dataManager = DataManager.shared
    
    
    private var recordsForSelectedDate: [Record] {
        dataManager.records.filter { record in
            Calendar.current.isDate(record.date, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    DatePicker(
                        "select a date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .handDrawnFrame()
                    
                    HandDrawnDivider()
                    
                    
                    if recordsForSelectedDate.isEmpty {
                        Text("There's no record of this day.")
                            .foregroundColor(.gray)
                            .italic()
                            .handDrawnFrame()
                    } else {
                        VStack(spacing: 15) {
                            ForEach(recordsForSelectedDate) { record in
                                RecordRow(record: record)
                                    .handDrawnFrame()
                            }
                        }
                        .padding()
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Record Calendar")
            .onAppear {
                dataManager.loadRecords()
            }
        }
    }
}


struct RecordRow: View {
    let record: Record
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 时间
            HStack {
                Image(systemName: "clock")
                Text(formatTime(record.date))
                    .font(.headline)
                Spacer()
                Text("time：\(formatDuration(record.duration))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            
            if let stool = record.stoolCondition {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("💩 poop")
                            .font(.headline)
                        
                        
                        if isWarningColor(stool.color) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    Text("type：\(stool.type.description)")
                    Text("color：\(stool.color.rawValue)")
                        .foregroundColor(getColorWarningStyle(stool.color))
                    Text("feeling：\(stool.feeling.rawValue)")
                }
            }
            
            
            if let urine = record.urineCondition {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("💧 pee")
                            .font(.headline)
                        
                    
                        if urine.color == .red {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    Text("color：\(urine.color.rawValue)")
                        .foregroundColor(urine.color == .red ? .red : .primary)
                    Text("volume：\(urine.volume.rawValue)")
                }
            }
            
            
            if let period = record.periodCondition {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("🌸 period")
                            .font(.headline)
                        
                        
                        if period.flow == .heavy {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    Text("this\(period.day)th day")
                    Text("flow：\(period.flow.rawValue)")
                        .foregroundColor(period.flow == .heavy ? .red : .primary)
                    if let note = period.note {
                        Text("note：\(note)")
                    }
                }
            }
        }
        .padding()
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d min%d sec", minutes, seconds)
    }
    
    
    private func isWarningColor(_ color: Record.StoolColor) -> Bool {
        return color == .red || color == .black || color == .white
    }
    
    
    private func getColorWarningStyle(_ color: Record.StoolColor) -> Color {
        switch color {
        case .red, .black, .white:
            return .red
        default:
            return .primary
        }
    }
}
