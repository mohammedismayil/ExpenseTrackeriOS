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
import Charts

struct Level3Widget: Widget {
    let kind = "Level3Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Level3TimeLineProvider()) { entry in
            Level3WidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.blue
                }
                
        }
        .description("Your spending at a glance")
        .configurationDisplayName("Today's Spend")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
    }
}

struct Level3WidgetView: View {
    let entry: Level3TimeLineEntry
    @Environment(\.widgetFamily) var family
    var body: some View {
        
        switch family {
        case .systemSmall:
            smallWidgetView.foregroundStyle(.white)
        case .systemMedium:
            mediumWidgetView.foregroundStyle(.white)
        case .accessoryCircular:
            accessoryCircularWidgetView
        default:
            EmptyView()
        }
    }
    
    var smallWidgetView: some View {
        VStack(alignment: .leading) {
            Image(systemName: "indianrupeesign")
                        .font(.headline)
                        .frame(width: 32, height: 32)
                        .background(.white.opacity(0.2), in: Circle())
            Spacer()
            Text("Today").font(.caption).foregroundStyle(.white.opacity(0.7))
            VStack(spacing: 10) {
                Text(entry.total, format: .currency(code: "INR").precision(.fractionLength(0)))
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .monospacedDigit()
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .layoutPriority(1)
                Text("of \(entry.budget, format: .currency(code: "INR").precision(.fractionLength(0)))")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                
            }
            
        }
    }
    
    var mediumWidgetView: some View {
        HStack {
            smallWidgetView
            Chart(entry.week) { spend in
                BarMark(x: .value("Date", spend.date, unit: .day),
                        y: .value("Amount", spend.amount))
                    .foregroundStyle(Calendar.current.isDateInToday(spend.date) ? .white : .white.opacity(0.4))
                    .cornerRadius(4)
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
                .frame(maxWidth: .infinity)
        }
    }
    
    var accessoryCircularWidgetView: some View {
        Gauge(value: min(entry.total, entry.budget), in: 0...entry.budget) {
            Image(systemName: "indianrupeesign")
        } currentValueLabel: {
            Text(entry.total, format: .number.notation(.compactName))
        }
        .gaugeStyle(.accessoryCircularCapacity)
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

//
//#Preview(as: .systemSmall)       { Level3Widget() } timeline: { Level3TimeLineEntry.sample }
//#Preview(as: .systemMedium)      { Level3Widget() } timeline: { Level3TimeLineEntry.sample }
//#Preview(as: .accessoryCircular) { Level3Widget() } timeline: { Level3TimeLineEntry.sample }
