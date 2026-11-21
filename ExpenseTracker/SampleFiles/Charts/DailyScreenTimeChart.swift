//
//  DailyScreenTimeChart.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 21/11/26.
//

import SwiftUI
import Charts

struct DailyScreenTimeChart: View {
    let calendar = Calendar.current
    private let today = Date()
    
    var body: some View {
        
        
        Chart(ScreenUsage.sampleData) { usage in
            BarMark(x: .value("Time",  usage.date), y: .value("Hours", usage.minutes))
                .foregroundStyle(by: .value("hourse", usage.usageType.rawValue))
            
        }.chartXAxis(content: {
            AxisMarks(values: [calendar.date(
                bySettingHour: 0,
                minute: 0,
                second: 0,
                of: today
            )!,
                               calendar.date(
                                bySettingHour: 6,
                                minute: 0,
                                second: 0,
                                of: today
                               )!,
                               calendar.date(
                                bySettingHour: 12,
                                minute: 0,
                                second: 0,
                                of: today
                               )!,
                               calendar.date(
                                bySettingHour: 18,
                                minute: 0,
                                second: 0,
                                of: today
                               )!,
                               calendar.date(
                                bySettingHour: 23,
                                minute: 0,
                                second: 0,
                                of: today
                               )!]) { value in
                                   AxisTick()
                                   AxisGridLine()
                                   AxisValueLabel(format: .dateTime.hour())
                               }
        })
//        .chartForegroundStyleScale([
//            "browsing": .blue,
//            "entertainment": .purple,
//            "education": .green,
//            "game": .orange
//        ])
        .chartLegend(.hidden)
        .frame(width: 250, height: 100)
    }
}

struct ScreenUsage: Identifiable {
    let id = UUID()
    let date: Date
    let minutes: Int
    let usageType: UsageType
    
    
    static let sampleData: [ScreenUsage] = {
        let calendar = Calendar.current
        let today = Date()
        
        func usage(
            hour: Int,
            minutes: Int,
            type: UsageType
        ) -> ScreenUsage {
            ScreenUsage(
                date: calendar.date(
                    bySettingHour: hour,
                    minute: 0,
                    second: 0,
                    of: today
                )!,
                minutes: minutes,
                usageType: type
            )
        }
        
        return [
            usage(hour: 8,  minutes: 20, type: .browsing),
            usage(hour: 8,  minutes: 15, type: .entertainment),
            
            usage(hour: 9,  minutes: 60, type: .entertainment),
            usage(hour: 10,  minutes: 60, type: .browsing),
            
            usage(hour: 12, minutes: 30, type: .education),
            usage(hour: 12, minutes: 20, type: .browsing),
            
            usage(hour: 18, minutes: 45, type: .game),
            
            usage(hour: 22, minutes: 35, type: .entertainment)
        ]
    }()
    
    enum UsageType: String {
        case entertainment
        case education
        case game
        case browsing
    }
}

#Preview {
    DailyScreenTimeChart()
}
