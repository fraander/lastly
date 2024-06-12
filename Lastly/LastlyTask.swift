//
//  LastlyTask.swift
//  Lastly
//
//  Created by Frank Anderson on 6/11/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class LastlyTask: Identifiable, Comparable {
    
    static let sample = LastlyTask(completions: [Date(timeIntervalSinceNow: -329145757), Date(timeIntervalSinceNow: -323297)], title: "Take out the trash")
    
    static func < (lhs: LastlyTask, rhs: LastlyTask) -> Bool {
        lhs.completions.sorted().first ?? Date() < rhs.completions.sorted().first ?? Date()
    }
    
    
    @Attribute(.unique) var id: UUID
    var completions: [Date]
    var title: String
    var tags: [LastlyTag] = []
    
    init(id: UUID = UUID(), completions: [Date] = [], title: String) {
        self.id = id
        self.completions = completions
        self.title = title
        self.tags = []
    }
}
