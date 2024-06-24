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
    
    @State var showInspector = false // TODO: setup inspector
    @State var selection: UUID?
    
    @State var showNewTag: Bool = false
    @State var newTagTitle: String = ""
    
    var newTagAction: some View {
        Button("New tag", systemImage: "plus") {
            showNewTag = true
        }
    }
    
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
                List(selection: $nav.currentTasks) { ByDateView() }
            }
            .customizationID("bydate")
            
            Tab("Inbox", systemImage: "tray", value: CurrentTab.inbox) {
                List(selection: $nav.currentTasks) { InboxView() }
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
                        List(selection: $nav.currentTasks) {
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
                newTagAction
                #if os(macOS)
                .popover(isPresented: $showNewTag) {
                    TextField("Title ...", text: $newTagTitle)
                        .frame(minWidth: 180)
                        .padding()
                }
#endif
            }
        }
        .onChange(of: nav.currentTasks) {
            if nav.currentTasks.count == 1 {
                showInspector = true
            } else {
                showInspector = false
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Add Tag", systemImage: "tag") {
                    showNewTag.toggle()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
#if os(iOS)
        .tabViewCustomization($tabViewCustomization)
#endif
        .sheet(isPresented: $showNewTag) {
            TextField("New tag title ...", text: $newTagTitle)
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
        .inspector(isPresented: $showInspector) {
            InspectorView(task: nav.currentTasks.first ?? LastlyTask(title: ""))
        }
    }
}

#Preview(/*traits: .sampleData*/) {
    
    let nav = NavigationManager()
    
    ContentView()
        .environmentObject(nav)
}
