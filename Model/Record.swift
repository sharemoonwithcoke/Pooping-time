//
//  Record.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.

import Foundation

struct Record: Identifiable, Codable {
    
    enum BristolType: Int, Codable, CaseIterable, Identifiable, Comparable {
        case type1 = 1
        case type2, type3, type4, type5, type6, type7
        
        var id: Int { rawValue }
        
        var description: String {
            switch self {
            case .type1: return "Hard and lumpy"
            case .type2: return "Striped and clumped"
            case .type3: return "striped and seamed"
            case .type4: return "Striped smooth"
            case .type5: return "soft"
            case .type6: return "paste-like"
            case .type7: return "Like water."
            }
        }
        
        
        static func < (lhs: BristolType, rhs: BristolType) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
    
    enum StoolColor: String, Codable, CaseIterable {
        case brown = "brown"
        case darkBrown = "dark brown"
        case black = "black"
        case green = "green"
        case red = "red"
        case yellow = "yellow"
        case white = "whilte"
    }
    
    enum Feeling: String, Codable, CaseIterable {
        case good = "good"
        case normal = "normal"
        case bad = "bad"
    }
    
    enum UrineColor: String, Codable, CaseIterable {
        case clear = "clear"
        case lightYellow = "light yellow"
        case darkYellow = "dark yellow"
        case red = "red"
    }
    
    enum UrineVolume: String, Codable, CaseIterable {
        case little = "little"
        case normal = "normal"
        case much = "much"
    }
    
    enum PeriodFlow: String, Codable, CaseIterable {
        case light = "light"
        case medium = "medium"
        case heavy = "heavy"
    }
    
    
    struct StoolCondition: Codable {
        var type: BristolType
        var color: StoolColor
        var feeling: Feeling
    }
    
    struct UrineCondition: Codable {
        var color: UrineColor
        var volume: UrineVolume
    }
    
    struct PeriodCondition: Codable {
        var day: Int
        var flow: PeriodFlow
        var note: String?
    }
    
    
    let id: UUID
    let date: Date
    let duration: TimeInterval
    var stoolCondition: StoolCondition?
    var urineCondition: UrineCondition?
    var periodCondition: PeriodCondition?
    
    
    init(id: UUID = UUID(),
         date: Date,
         duration: TimeInterval,
         stoolCondition: StoolCondition? = nil,
         urineCondition: UrineCondition? = nil,
         periodCondition: PeriodCondition? = nil) {
        self.id = id
        self.date = date
        self.duration = duration
        self.stoolCondition = stoolCondition
        self.urineCondition = urineCondition
        self.periodCondition = periodCondition
    }
}

extension Record {
    enum HealthAlert {
        case emergency(String)
        case warning(String)
        case needConfirm(String)
    }
    
    func checkHealthAlert() -> HealthAlert? {
        guard let stool = stoolCondition else { return nil }
        
    
        switch stool.color {
        case .white:
            return .emergency("white poop may indicate severe gastrointestinal bleeding. Please seek immediate medical attention.")
        case .black:
            return .needConfirm("do you have eaten something  like Iron supplements?\n if not,please cousult a doctor")
        case .red:
            return .needConfirm(" do you have eaten something like red dragon fruit or red bell pepper？\n if not, red poop may indicate severe gastrointestinal bleeding. Please seek immediate medical attention.")
        case .green:
            if isConsecutiveDays(withColor: .green, days: 2) {
                return .warning("you have more than 2 days of green poop, please consult a doctor")
            }
        default:
            break
        }
        
        
        if stool.type == .type6 || stool.type == .type7 {
            if isConsecutiveDays(withType: stool.type, days: 3) {
                return .warning("you already have 3 days of hard or dry stool, please consult a doctor")
            }
        }
        
        if stool.type == .type1 || stool.type == .type2 {
            if isConsecutiveDays(withType: stool.type, days: 5) {
                return .warning("5 consecutive days of constipation, increased fiber intake and exercise recommended")
            }
        }
        
        return nil
    }
    
    private func isConsecutiveDays(withType type: BristolType, days: Int) -> Bool {
        let recentRecords = DataManager.shared.records
            .filter { $0.stoolCondition?.type == type }
            .sorted { $0.date > $1.date }
        
        guard recentRecords.count >= days else { return false }
        
        let calendar = Calendar.current
        for i in 0..<(days-1) {
            let daysBetween = calendar.dateComponents([.day],
                                                    from: recentRecords[i+1].date,
                                                    to: recentRecords[i].date).day ?? 0
            if daysBetween != 1 {
                return false
            }
        }
        return true
    }
    
    private func isConsecutiveDays(withColor color: StoolColor, days: Int) -> Bool {
        let recentRecords = DataManager.shared.records
            .filter { $0.stoolCondition?.color == color }
            .sorted { $0.date > $1.date }
        
        guard recentRecords.count >= days else { return false }
        
        let calendar = Calendar.current
        for i in 0..<(days-1) {
            let daysBetween = calendar.dateComponents([.day],
                                                    from: recentRecords[i+1].date,
                                                    to: recentRecords[i].date).day ?? 0
            if daysBetween != 1 {
                return false
            }
        }
        return true
    }
}
