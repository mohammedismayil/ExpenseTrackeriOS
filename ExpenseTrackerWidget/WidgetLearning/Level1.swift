//
//  Level1.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 18/11/26.
//

import WidgetKit
import Foundation
import SwiftUI

struct CategorySpend: Identifiable {
    let id = UUID()
    let amount: Double
    let name: String
    let symbol: String
}

struct Level1Widget: Widget {
    let kind = "Level1Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Level1TimeLineProvider()) { entry in
            Level1WidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                .foregroundStyle(.white)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Level1TimeLineProvider: TimelineProvider {
    typealias Entry = Level1TimeLineEntry
    func getSnapshot(in context: Context, completion: @escaping (Level1TimeLineEntry) -> Void) {
        completion(Level1TimeLineEntry.sample)
    }
    
    func placeholder(in context: Context) -> Level1TimeLineEntry {
        Level1TimeLineEntry.sample
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Level1TimeLineEntry>) -> Void) {
        completion(Timeline(entries: [Level1TimeLineEntry.sample], policy: .never))
    }
}

struct Level1TimeLineEntry: TimelineEntry {
    let date: Date
    let spending: [CategorySpend]
    let total: Double
    static let sample: Level1TimeLineEntry = Level1TimeLineEntry(date: .now, spending: [
        .init(amount: 540, name: "Food", symbol: "fork.knife"),
        .init(amount: 420, name: "Transport", symbol: "car.fill"),
        .init(amount: 280, name: "Shopping", symbol: "bag.fill")], total: 1240)
}



struct Level1WidgetView: View {
    let entry: Level1TimeLineEntry
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family {
        case .systemSmall:
            smallWidgetView
        case .systemMedium:
            HStack(spacing: 16) {
                smallWidgetView
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(entry.spending) { spend in
                        
                        HStack {
                            Image(systemName: spend.symbol).frame(width: 20)
                            Text(spend.name)
                            Spacer()
                            Text(spend.amount, format: .currency(code: "INR").precision(.fractionLength(0)))
                        }
                       
                    }
                    
                }
                
            }
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
            Text(entry.total, format: .currency(code: "INR").precision(.fractionLength(0)))
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
        }
        
    }
}

#Preview(as: .systemSmall) {
    Level1Widget()
} timeline: {
    Level1TimeLineEntry.sample
}

#Preview(as: .systemMedium) {
    Level1Widget()
} timeline: {
    Level1TimeLineEntry.sample
}
