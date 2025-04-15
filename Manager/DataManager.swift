//
//  DataManager.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    @Published var records: [Record] = []
    
    private let recordsKey = "health_records"
    
    private init() {
        loadRecords()
    }
    
    func saveRecord(_ record: Record) {
        records.append(record)
        saveRecords()
        objectWillChange.send()
    }
    
    private func saveRecords() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(records)
            UserDefaults.standard.set(data, forKey: recordsKey)
            UserDefaults.standard.synchronize()
        } catch {
            print("Record keeping failure: \(error.localizedDescription)")
        }
    }
    
    func loadRecords() {
        guard let data = UserDefaults.standard.data(forKey: recordsKey) else {
            records = []
            return
        }
        
        do {
            let decoder = JSONDecoder()
            records = try decoder.decode([Record].self, from: data)
            objectWillChange.send()
        } catch {
            print("Failed to load record： \(error.localizedDescription)")
            records = []
        }
    }
}


