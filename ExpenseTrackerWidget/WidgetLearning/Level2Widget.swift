//
//  Level2Widget.swift
//  ExpenseTrackerWidgetExtension
//
//  Created by Mohammed Ismayil on 19/11/26.
//

import Foundation
import WidgetKit
import Foundation
import SwiftUI

struct Level2Widget: Widget {
    let kind = "Level2Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Level2TimeLineProvider()) { entry in
            Level2WidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(colors: entry.timeOfDay.colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                .foregroundStyle(.white)
        }
        .description("Your day time")
        .configurationDisplayName("Your day")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Level2TimeLineProvider: TimelineProvider {
    typealias Entry = Level2TimeLineEntry
    func getSnapshot(in context: Context, completion: @escaping (Level2TimeLineEntry) -> Void) {
        completion(Level2TimeLineEntry.sample)
    }
    
    func placeholder(in context: Context) -> Level2TimeLineEntry {
        Level2TimeLineEntry.sample
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Level2TimeLineEntry>) -> Void) {
        let calendar = Calendar.current
        var dates: [Date] = [.now]
        for hour in [5, 12, 17, 21] {
            if let next = calendar.nextDate(after: .now,
                                            matching: DateComponents(hour: hour),
                                            matchingPolicy: .nextTime) {
                dates.append(next)
            }
        }
        
        let entries = dates.sorted().map({Level2TimeLineEntry(date: $0, total: 100)})

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct Level2TimeLineEntry: TimelineEntry {
    let date: Date
    var timeOfDay: TimeOfDay {
            TimeOfDay(hour: Calendar.current.component(.hour, from: date))
        }
    var total: Double
    static let sample: Level2TimeLineEntry = Level2TimeLineEntry(date: .now, total: 10)
}



struct Level2WidgetView: View {
    let entry: Level2TimeLineEntry
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: entry.timeOfDay.symbol).font(.title)
            
            Spacer()
            Text(entry.timeOfDay.greeting).font(.system(.title3, design: .rounded, weight: .bold))
            Text(entry.total, format: .currency(code: "INR").precision(.fractionLength(0)))
                .font(.system(.title, design: .rounded, weight: .bold))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }.frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

enum TimeOfDay {
    case morning
    case afternoon
    case evening
    case night
    
    var symbol: String {
        switch self {
        case .morning:
            "sun.max.fill"
        case .afternoon:
            "cloud.sun.fill"
        case .evening:
            "sunset.fill"
        case .night:
            "moon.stars.fill"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .morning:   // warm sunrise: orange into rose
            [Color(red: 0.90, green: 0.38, blue: 0.05),
             Color(red: 0.80, green: 0.20, blue: 0.35)]
        case .afternoon: // daytime sky: blue into teal
            [Color(red: 0.08, green: 0.38, blue: 0.80),
             Color(red: 0.10, green: 0.58, blue: 0.78)]
        case .evening:   // sunset: red-orange into purple
            [Color(red: 0.85, green: 0.30, blue: 0.20),
             Color(red: 0.45, green: 0.15, blue: 0.55)]
        case .night:     // deep indigo into near-black
            [Color(red: 0.15, green: 0.10, blue: 0.45),
             Color(red: 0.02, green: 0.02, blue: 0.12)]
        }
    }
    
    var greeting: String {
        switch self {
        case .morning:
            "Good Morning"
        case .afternoon:
            "Good Afternoon"
        case .evening:
            "Good Evening"
        case .night:
            "Good Night"
        }
    }
    
    init(hour: Int) {
            switch hour {
            case 5..<12:  self = .morning
            case 12..<17: self = .afternoon
            case 17..<21: self = .evening
            default:      self = .night
            }
        }

}

private func at(_ hour: Int) -> Date {
    Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: .now)!
}

#Preview(as: .systemSmall) {
    Level2Widget()
} timeline: {
    Level2TimeLineEntry(date: at(8), total: 120)
    Level2TimeLineEntry(date: at(14), total: 120)
    Level2TimeLineEntry(date: at(18), total: 120)
    Level2TimeLineEntry(date: at(23), total: 120)
}
