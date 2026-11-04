//
//  ExpenseTrackerWidget.swift
//  ExpenseTrackerWidget
//
//  Created by Mohammed Ismayil on 29/10/26.
//

import WidgetKit
import SwiftUI
import AppIntents


struct ExpenseTrackerWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "ExpenseTrackerWidget", intent: ExpenseTrackerWidgetIntent.self, provider: ExpenseTrackerWidgetProvider()) { entry in
            ExpenseTrackerWidgetView(entry: entry)
        }
    }
}

struct ExpenseTrackerWidgetView: View {
    var entry: ExpenseTrackerWidgetTimeLine
    var body: some View {
        VStack {
            Text("Total expense").font(.caption)
            Text(entry.totalExpense,format: .currency(code: "INR"))
        }
        .containerBackground(for: .widget) {
                Color.blue // Or any ShapeStyle/View
            }
    }
}


struct ExpenseTrackerWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Your total expense"
}

struct ExpenseTrackerWidgetTimeLine: TimelineEntry {
    let date: Date
    let totalExpense: Double
}

struct ExpenseTrackerWidgetProvider: AppIntentTimelineProvider {
   typealias Entry = ExpenseTrackerWidgetTimeLine
    typealias Intent = ExpenseTrackerWidgetIntent
    
    let defaults = UserDefaults(
        suiteName: "group.ismayil.ExpenseTracker"
    )
    
    func placeholder(in context: Context) -> Entry {
        ExpenseTrackerWidgetTimeLine(date: Date(), totalExpense: 0)
    }
    
    func snapshot(for configuration: Intent, in context: Context) async -> ExpenseTrackerWidgetTimeLine {
        let expense = defaults?.double(forKey: "totalexpense") ?? 2000
        return ExpenseTrackerWidgetTimeLine(date: Date(), totalExpense: expense)
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<ExpenseTrackerWidgetTimeLine> {
        let defaults = UserDefaults(
            suiteName: "group.ismayil.ExpenseTracker"
        )
        
        print("WIDGET DEFAULTS:", defaults as Any)
        print("WIDGET VALUE:", defaults?.object(forKey: "totalexpense") as Any)
        print("WIDGET DOUBLE:", defaults?.double(forKey: "totalexpense") ?? -1)
        
        let expense = defaults?.double(forKey: "totalexpense") ?? 2000
        return Timeline(entries: [ExpenseTrackerWidgetTimeLine(date: Date(), totalExpense: expense)], policy: .atEnd)
    }
    
}
