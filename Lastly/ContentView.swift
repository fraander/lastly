//
//  ContentView.swift
//  Lastly
//
//  Created by Frank Anderson on 6/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var nav: NavigationManager
    @Environment(\.modelContext) var modelContext
    @FocusedValue(\.globalFocusedValue) var gfv
    
    #if os(iOS)
    @AppStorage("TabViewCustomization") private var tabViewCustomization: TabViewCustomization
    #endif
    
    @Query(sort: [SortDescriptor(\LastlyTag.title, order: .forward)]) private var tags: [LastlyTag]
    @Query(filter: #Predicate<LastlyTask> {$0.tags.isEmpty}) private var tasks: [LastlyTask]
    
    @State var selection: UUID?
    
    @State var showNewTag: Bool = false
    @State var newTagTitle: String = ""
    
    var body: some View {
        TabView(selection: $nav.currentTab) {
            Tab("Home", systemImage: "house", value: CurrentTab.home) {
                HomeView()
            }
            .customizationID("home")
            #if os(iOS)
            .customizationBehavior(.disabled, for: .sidebar, .tabBar)
            #endif
            
            Tab("All", systemImage: "calendar", value: CurrentTab.byDate) {
                List { ByDateView() }
            }
            .customizationID("bydate")
            
            Tab("Inbox", systemImage: "tray", value: CurrentTab.inbox) {
                List { InboxView() }
            }
            .badge(tasks.count)
            .customizationID("inbox")
            
            Tab(value: CurrentTab.search, role: .search) {
                NavigationStack {
                    SearchView()
                }
            }
            .customizationID("search")
            
            TabSection("Tags") {
                ForEach(tags) { tag in
                    Tab(tag.title,
                        systemImage: "tag",
                        value: CurrentTab.tag(from: tag.id)
                    ) {
                        List {
                            TagListView(tag: tag)
                        }
                    }
                    .badge(tag.tasks.count)
                    .customizationID("tag-\(tag.id)")
                }
            }
            #if os(iOS)
            .defaultVisibility(.hidden, for: .tabBar)
            #endif
            .sectionActions {
                Button("New tag", systemImage: "plus") {
                    showNewTag = true
                }
                #if os(macOS)
                .popover(isPresented: $showNewTag) {
                    TextField("Title ...", text: $newTagTitle)
                        .frame(minWidth: 180)
                        .padding()
                }
                #endif
            }
        }
        .toolbar {
            if let gfvSafe = gfv {
                Text(gfvSafe.description)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
#if os(iOS)
        .tabViewCustomization($tabViewCustomization)
#endif
#if os(iOS)
        .sheet(isPresented: $showNewTag) {
            TextField("Title ...", text: $newTagTitle)
                .onSubmit {
                    if !newTagTitle.isEmpty {
                        modelContext.insert(LastlyTag(title: newTagTitle))
                        newTagTitle = ""
                        showNewTag = false
                    }
                }
                .frame(minWidth: 180)
                .padding()
        }
#endif
    }
}

#Preview(traits: .sampleData) {
    
    let nav = NavigationManager()
    
    ContentView()
        .environmentObject(nav)
}
