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
    
    func placeholder(in context: Context) -> Entry {
        ExpenseTrackerWidgetTimeLine(date: Date(), totalExpense: 0)
    }
    
    func snapshot(for configuration: ExpenseTrackerWidgetIntent, in context: Context) async -> ExpenseTrackerWidgetTimeLine {
        return ExpenseTrackerWidgetTimeLine(date: Date(), totalExpense: 3000)
    }
    
    func timeline(for configuration: ExpenseTrackerWidgetIntent, in context: Context) async -> Timeline<ExpenseTrackerWidgetTimeLine> {
        return Timeline(entries: [ExpenseTrackerWidgetTimeLine(date: Date(), totalExpense: 3000)], policy: .atEnd)
    }
    
}
