//
//  Level3Widget.swift
//  ExpenseTrackerWidgetExtension
//
//  Created by Mohammed Ismayil on 20/11/26.
//

import Foundation
import WidgetKit
import Foundation
import SwiftUI

struct Level3Widget: Widget {
    let kind = "Level3Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Level3TimeLineProvider()) { entry in
            Level3WidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.blue
                }
                .foregroundStyle(.white)
        }
        .description("Your spending at a glance")
        .configurationDisplayName("Today's Spend")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Level3WidgetView: View {
    let entry: Level3TimeLineEntry
    var body: some View {
        Text(entry.budget,format: .number)
    }
    
    var smallWidgetView: some View {
        VStack(alignment: .leading) {
            Image(systemName: "indianrupeesign")
                .font(.headline)
                .frame(width: 32, height: 32)
                .background(.white.opacity(0.2), in: Circle())
            Spacer()
            Text("Today").font(.caption).foregroundStyle(.white.opacity(0.7))
            Text(entry.total, format: .currency(code: "INR").precision(.fractionLength(0)))
                .font(.system(.title, design: .rounded, weight: .bold))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        
    }
}

struct Level3TimeLineProvider: TimelineProvider {
    typealias Entry = Level3TimeLineEntry
    func getSnapshot(in context: Context, completion: @escaping (Level3TimeLineEntry) -> Void) {
        completion(Level3TimeLineEntry.sample)
    }
    
    func placeholder(in context: Context) -> Level3TimeLineEntry {
        Level3TimeLineEntry.sample
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Level3TimeLineEntry>) -> Void) {
        completion(Timeline(entries: [Level3TimeLineEntry.sample], policy: .never))
    }
}

struct Level3TimeLineEntry: TimelineEntry {
    let date: Date
    let total: Double        // today's spend
    let budget: Double       // daily budget
    let week: [DailySpend]   // last 7 days, oldest first
    
    static let sample = Level3TimeLineEntry(
        date: .now,
        total: 1240,
        budget: 2000,
        week: (0..<7).map { offset in
            DailySpend(
                date: Calendar.current.date(byAdding: .day, value: offset - 6, to: .now)!,
                amount: [820, 1500, 640, 1900, 1100, 300, 1240][offset]
            )
        }
    )
}






struct DailySpend: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}
