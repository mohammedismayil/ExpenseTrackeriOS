//
//  PhoneCallActivity.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 22/11/26.
//

import Foundation
import ActivityKit
import SwiftUI
import WidgetKit


struct PhoneCallActivityView: View {
    let model: ActivityViewContext<PhoneCallActivityAttributes>
    var body: some View {
        Text("John doe")
    }
}

struct PhoneCallActivityExpandedLeadingView: View {
    var body: some View {
        HStack(spacing: 8) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Sams machan")
                        .font(.headline)

                    Text("Video call")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        
        
    }
}
struct PhoneCallActivityExpandedTrailingView: View {
    var body: some View {
        Text("John doe")
    }
}
struct PhoneCallActivityExpandedCenterView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sams machan")
                .font(.headline)
            
            Text("Video call")
                .font(.caption)
                .foregroundStyle(.secondary)
        }.padding(.leading,-50)
        Spacer()
    }
}

struct PhoneCallActivityExpandedBottomView: View {
    var body: some View {
        HStack {
            Image(systemName: "mic.slash.fill").resizable()
            Image(systemName: "speaker.wave.2.fill").resizable()
            Image(systemName: "phone.down.fill").resizable()
        }
    }
}

struct PhoneCallActivityLeadingView: View {
    var body: some View {
        Text("John doe")
    }
}
struct PhoneCallActivityTrailingView: View {
    var body: some View {
        Image(systemName: "info").resizable().frame(width: 30,height: 30).foregroundStyle(.fill)
    }
}
struct PhoneCallActivityMinimalView: View {
    var body: some View {
        Text("John doe")
    }
}

struct PhoneCallActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PhoneCallActivityAttributes.self) { context in
            PhoneCallActivityView(model: context)
        } dynamicIsland: { context in
            
            DynamicIsland {
                
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "profile").resizable().frame(width: 30,height: 30)
                    VStack(alignment: .leading) {
                        Text("Sams machan")
                        Text("8:00")
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    DebugRegionView(name: "Trailing", color: .gray)
                }
                DynamicIslandExpandedRegion(.center) {
                    DebugRegionView(name: "Center", color: .green)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    DebugRegionView(name: "Bottom", color: .purple)
                }
            } compactLeading: {
                PhoneCallActivityLeadingView()
            } compactTrailing: {
                PhoneCallActivityTrailingView()
            } minimal: {
                PhoneCallActivityMinimalView()
            }

        }

    }
}

struct PhoneCallActivityAttributes: ActivityAttributes {
    typealias ContentState = PhoneCallActivityState
    
    struct PhoneCallActivityState: Codable, Hashable {
        let callState: CallState
        
        enum CallState: String, Codable {
            case hold
            case onCall
        }
    }
    
}

struct DebugRegionView: View {
    let name: String
    let color: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                color.opacity(0.25)

                VStack(spacing: 2) {
                    Text(name)
                        .font(.caption)
                        .bold()

                    Text("\(Int(proxy.size.width)) × \(Int(proxy.size.height))")
                        .font(.caption2)
                }
                .foregroundStyle(color)
            }
            .overlay {
                Rectangle()
                    .stroke(color, lineWidth: 2)
            }
        }
    }
}
