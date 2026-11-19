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
                    LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                .foregroundStyle(.white)
        }
        .description("Your day time")
        .configurationDisplayName("Your day")
        .supportedFamilies([.systemSmall , .systemMedium])
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
        for hour in [6, 12, 17, 21] {
            if let next = calendar.nextDate(after: .now,
                                            matching: DateComponents(hour: hour),
                                            matchingPolicy: .nextTime) {
                dates.append(next)
            }
        }
        
        let entries = dates.sorted().map({Level2TimeLineEntry(date: $0)})

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct Level2TimeLineEntry: TimelineEntry {
    let date: Date
    var timeOfDay: TimeOfDay {
            TimeOfDay(hour: Calendar.current.component(.hour, from: date))
        }
    static let sample: Level2TimeLineEntry = Level2TimeLineEntry(date: .now)
}



struct Level2WidgetView: View {
    let entry: Level2TimeLineEntry
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.timeOfDay.greeting)
        }
        
    }
}

enum TimeOfDay {
    case morning
    case afternoon
    case evening
    case night
    
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
