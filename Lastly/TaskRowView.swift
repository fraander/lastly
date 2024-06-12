//
//  TaskRowView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/12/24.
//

import SwiftUI
import SwiftData

enum DrawPhase {
    case drawOn, drawOff, wait
}

enum Focused: Hashable, CustomStringConvertible {
    case task(_ task: LastlyTask), empty
    
    var description: String {
        switch self {
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

struct TaskRowView: View {
    var task: LastlyTask
    
    @State private var line: DrawPhase = .wait
    @FocusState private var focus: Focused?
    
    var body: some View {
        HStack {
            Button("Complete", systemImage: "arrow.right", action: completeTask)
                .buttonStyle(.plain)
                .labelStyle(.iconOnly)
                .foregroundStyle(Color.accentColor)
                .font(.system(.headline, design: .rounded, weight: .medium))
            
            ZStack(alignment: .leading) {
                TextField("Take out the trash ...", text: Binding(
                    get: { task.title },
                    set: { task.title = $0 }
                ))
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(.plain)
                .focused($focus, equals: .task(task))
                .focusedValue(\.globalFocusedValue, .task(task))
                
                Text(task.title)
                    .opacity(0)
                    .lineLimit(1)
                    .font(.system(.body, design: .rounded))
                    .overlay {
                        HStack {
                            Spacer()
                                .frame(maxWidth: line == .drawOff ? .infinity : 0)
                            
                            Capsule()
                                .fill(Color.secondary)
                                .frame(maxWidth: line == .drawOn ? .infinity : 0)
                                .frame(maxHeight: 1.5)
                                .offset(y: 0.75)
                            
                            Spacer()
                                .frame(maxWidth: line != .wait ? 0 : .infinity)
                        }
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focus = .task(task)
            }
            
            Spacer()
            
            if let first = task.completions.sorted().last {
                Text(Date.now, format: .reference(to: first, allowedFields: [.day, .minute,. hour, .month], thresholdField: .month))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(Color.secondary)
                    .contentTransition(.numericText())
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button("Complete", systemImage: "arrow.right", action: completeTask)
                .foregroundStyle(Color.accentColor)
                .font(.system(.headline, design: .rounded, weight: .medium))

        }
    }
    
    func completeTask() {
        withAnimation(.easeIn(duration: 0.3)) {
            line = .drawOn
            task.completions.append(Date())
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation(.easeInOut(duration: 0.15)) {
                line = .drawOff
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                line = .wait
        }
    }
}

#Preview(traits: .sampleData) {
    
    let nav = NavigationManager()
    
    List(0..<1) { _ in
        TaskRowView(task: .sample)
    }
    .environmentObject(nav)
}
