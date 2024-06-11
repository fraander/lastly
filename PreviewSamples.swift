//
//  PreviewSamples.swift
//  Lastly
//
//  Created by Frank Anderson on 6/11/24.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor func makeSamples(in container: ModelContainer) {
    
    // **Sample tasks**
    let sampleTitles = ["Mop the floors",
    "Dust furniture and shelves",
    "Organize a drawer or cabinet",
    "Take out the trash and recycling",
    "Clean the bathroom mirrors and faucets",
    "Water houseplants",
    "Vacuum carpets and rugs",
    "Fold and put away laundry",
    "Wipe down kitchen counters and appliances",
    "Clean out the refrigerator"]
    
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate]
    
    for sampleTitle in sampleTitles { // create 10 tasks
        
        // with 0 -> 5 dates
        var dates: [Date] = []
        for _ in 0..<Int.random(in: 0..<5) {
            let yyyy = Int.random(in: 2023...2024)
            let mm = Int.random(in: 1...12)
            let dd = Int.random(in: 1...31)
            
            if let randDate = formatter.date(from: "\(yyyy)-\(mm)-\(dd)") {
                dates.append(randDate)
            }
        }
        
        container.mainContext.insert(
            LastlyTask(
                completions: dates.sorted(), //sort dates
                title: sampleTitle // use the title
            )
        )
    }
    
    let today = LastlyTask(completions: [Date()], title: "Today's completion")
    container.mainContext.insert(today)
    
    let weeks = LastlyTask(completions: [Date(timeIntervalSinceNow: -1800000)], title: "a few weeks ago")
    container.mainContext.insert(weeks)
    
    let days = LastlyTask(completions: [Date(timeIntervalSinceNow: -400000)], title: "a few days ago")
    container.mainContext.insert(days)
    
    let mins = LastlyTask(completions: [Date(timeIntervalSinceNow: -3000)], title: "a few minutes ago")
    container.mainContext.insert(mins)
    
    let never = LastlyTask(title: "Never did this")
    container.mainContext.insert(never)
    
    
    // **Sample tags**
    container.mainContext.insert(LastlyTag(title: "Samples", tasks: [today, weeks, days]))
    container.mainContext.insert(LastlyTag(title: "Others", tasks: [mins, weeks, never, days]))
    container.mainContext.insert(LastlyTag(title: "Empty"))
}

struct SampleLastlyTasks: PreviewModifier {
    static func makeSharedContext() async throws -> Context {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: LastlyTask.self, configurations: config)
        makeSamples(in: container)
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleLastlyTasks())
}
