//
//  InspectorView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/21/24.
//

import SwiftUI
import SwiftData

struct InspectorView: View {
    
    @EnvironmentObject var nav: NavigationManager
    @Query var tags: [LastlyTag]
        
    var currentTagsListFormat: String {
        
        let defaultMessage = "No tags"
        
        if let current = nav.currentTasks.first?.tags {
            if current.isEmpty {
                return defaultMessage
            } else {
                return ListFormatter.localizedString(byJoining: current.map(\.title))
            }
        }
        
        return defaultMessage
    }
    
    var body: some View {
        Group {
            if let inspecting = nav.currentTasks.first {
                Form {
                    Section("Completions") {
                        List {
                            if inspecting.completions.isEmpty {
                                Text("This task has never been completed.")
                            } else {
                                ForEach(inspecting.completions, id: \.self) { completion in
                                    Text(Date.now, format: .reference(to: completion, allowedFields: [.day, .minute,. hour, .month], thresholdField: .month))
                                }
                            }
                        }
                    }
                    
                    Section("Tags") {
                        Menu("\(currentTagsListFormat)", systemImage: "tag") {
                            ForEach(tags) { tag in
                                Text(tag.title)
                                #warning("doesn't work yet-- have to make it so clicking adds or removes 👍")
                            }
                        }
                    }
                }
            }
        }
    }
}

