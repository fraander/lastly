//
//  NavManager.swift
//  Lastly
//
//  Created by Frank Anderson on 6/11/24.
//

import Foundation

enum CurrentTab: Hashable {
    case home, inbox, search, byDate, tag(from: UUID)
}

@Observable
class NavigationManager: ObservableObject {
    var currentTab: CurrentTab? = nil
}
