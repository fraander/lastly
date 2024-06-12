//
//  Focused.swift
//  Lastly
//
//  Created by Frank Anderson on 6/12/24.
//

import SwiftUI

enum Focused: Hashable, CustomStringConvertible {
    case task(_ task: LastlyTask), newTask, empty
    
    var description: String {
        switch self {
        case .newTask:
            "New Task"
        case .task(let t):
            t.title
        case .empty:
            ""
        }
    }
}

struct GlobalFocusedKey: FocusedValueKey {
    typealias Value = Focused
}

extension FocusedValues {
    var globalFocusedValue: GlobalFocusedKey.Value? {
        get { self[GlobalFocusedKey.self] }
        set { self[GlobalFocusedKey.self] = newValue }
    }
}
