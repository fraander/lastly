//
//  TaskAddBar.swift
//  Lastly
//
//  Created by Frank Anderson on 6/12/24.
//

import SwiftUI

struct TaskAddBar: View {
    @Environment(\.modelContext) var modelContext
    
    var destination: LastlyTag?
    
    @FocusState private var focus: Focused?
    @State var newTitle = ""
    
    @State var placeholderSuggestion: String = Samples.suggestTitle(current: "")
    @State var autofillSuggestions: [String] = []
    
    var isTitleValid: Bool {
        return !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            
            Image(systemName: "arrow.right")
                .opacity(0)
            
            TextField("\(placeholderSuggestion)...", text: $newTitle)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(.plain)
                .focused($focus, equals: .newTask)
                .focusedValue(\.globalFocusedValue, .newTask)
                .onSubmit(addTask)
                .padding(.vertical, 4)
                .onChange(of: isTitleValid) { old, new in
                    if new != false {
                        autofillSuggestions = Samples.makeSuggestions(numbering: 3)
                        placeholderSuggestion = Samples.suggestTitle(current: autofillSuggestions + [placeholderSuggestion])
                        
                    }
                }
            #if os(macOS)
                .textInputSuggestions {
                    if !isTitleValid {
                        ForEach(
                            autofillSuggestions, id: \.self
                        ) { stt in
                            Text(stt).textInputCompletion(stt)
                        }
                    }
                }
            #endif
            
            Button {
                addTask()
            } label: {
                HStack {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.accentColor)
                        .font(.system(.headline, design: .rounded, weight: .medium))
                    
                    
                    Text("Add to \(destination?.title ?? "Inbox")")
                        .font(.system(.headline, design: .rounded, weight: .regular))
                }
            }
        }   
    }
    
    func addTask() {
        // TODO: add the task to the correct list
        let cleaned = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleaned.isEmpty {
            focus = .newTask
        } else {
            
            let newTask = LastlyTask(title: cleaned)
            
            modelContext.insert(newTask)
            destination?.tasks.append(newTask)
            
            newTitle = ""
        }
    }
}

#Preview(traits: .sampleData) {
    
    let nav = NavigationManager()
    
    List {
        ForEach(0..<1) { _ in
            TaskRowView(task: .sample)
        }
        TaskAddBar()
    }
    .environmentObject(nav)
}
