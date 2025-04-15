//AlertType.swift
//  Pooping-time
//
//  Created by yueming on 2/10/25.
import Foundation

enum AlertType: Equatable {
    case none
    case emergency(message: String)
    case warning(message: String)
    case confirmation(message: String)
}
