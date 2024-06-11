//
//  LastlyTag.swift
//  Lastly
//
//  Created by Frank Anderson on 6/11/24.
//

import Foundation
import SwiftData

@Model
class LastlyTag: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    @Relationship(inverse: \LastlyTask.tags) var tasks: [LastlyTask] = []
    
    init(id: UUID = UUID(), title: String, tasks: [LastlyTask] = []) {
        self.id = id
        self.title = title
        self.tasks = tasks
    }
}
