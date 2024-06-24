//
//  InspectorView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/21/24.
//

import SwiftUI
import SwiftData

struct InspectorView: View {
    
    var task: LastlyTask
    @Query var tags: [LastlyTag]
    
    @State var selectedTags: Set<LastlyTag> = []
    @State var showTagsPicker = false
    
    var hasTags: Bool {
        return !task.tags.isEmpty
    }
    
    var currentTagsListFormat: String {
        if task.tags.isEmpty {
            return "No tags"
        } else {
            return ListFormatter.localizedString(byJoining: task.tags.map(\.title))
        }
    }
    
    var body: some View {
        Group {
            Form {
                Section("Completions") {
                    List {
                        if task.completions.isEmpty {
                            Text("This task has never been completed.")
                        } else {
                            ForEach(task.completions, id: \.self) { completion in
                                Text(Date.now, format: .reference(to: completion, allowedFields: [.day, .minute,. hour, .month], thresholdField: .month))
                            }
                        }
                    }
                }
                
                Section("Tags") {
                    Button("\(currentTagsListFormat)", systemImage: hasTags ? "tag.fill" : "tag") { showTagsPicker = true }
                        .popover(isPresented: $showTagsPicker) {
                            List(tags) { tag in
                                Button(
                                    tag.title,
                                    systemImage: task.tags.contains(tag) ? "checkmark.circle.fill" : "checkmark.circle"
                                ) {
                                    if task.tags.contains(tag) {
                                        task.tags.removeAll { lt in
                                            lt.id == tag.id
                                        }
                                    } else {
                                        task.tags.append(tag)
                                    }
                                }
                                .buttonStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                }
            }
        }
    }
}
