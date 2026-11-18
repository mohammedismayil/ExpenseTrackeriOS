//
//  StaticWidget.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 18/11/26.
//
import WidgetKit
import SwiftUI

struct StaticWidget: Widget {
    let kind: String = "StaticWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StaticTimeLineProvider()) { entry in
            StaticWidgetView()
        }
    }
}

struct StaticWidgetView: View {
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family {
        case .systemSmall:
            smallSizeWidget
        case .systemMedium:
            mediumSizeWidget
        default:
            EmptyView()
        }
    }
    
    var smallSizeWidget: some View {
        return Text("Hey there")
    }
    
    @ViewBuilder
    var mediumSizeWidget: some View {
        Text("Hey there")
        Text("Welcome")
    }
}


struct StaticTimeLineProvider: TimelineProvider {
    typealias Entry = StaticTimeLineEntry
    
    func placeholder(in context: Context) -> StaticTimeLineEntry {
        StaticTimeLineEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StaticTimeLineEntry) -> Void) {
        completion(StaticTimeLineEntry(date: .now))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StaticTimeLineEntry>) -> Void) {
        completion(Timeline(entries: [StaticTimeLineEntry(date: .now)], policy: .never))
    }
    
    
}

struct StaticTimeLineEntry: TimelineEntry {
    let date: Date
}
