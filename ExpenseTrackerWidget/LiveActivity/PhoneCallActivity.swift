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
        }.padding(.top,12)
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
                    HStack(spacing: 10) {
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.gray.opacity(0.65),
                                        Color.purple.opacity(0.45)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 58, height: 58)
                            .overlay {
                                Text("S")
                                    .font(.system(
                                        size: 30,
                                        weight: .medium
                                    ))
                                    .foregroundStyle(.white)
                            }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            
                            Text("Sams machan")
                                .font(.system(
                                    size: 17,
                                    weight: .semibold
                                ))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            
                            Text("04:29")
                                .font(.system(
                                    size: 17,
                                    weight: .regular
                                ))
                                .foregroundStyle(.gray)
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    PhoneCallActivityExpandedTrailingView()
                }
                DynamicIslandExpandedRegion(.center) {
                    PhoneCallActivityExpandedCenterView()
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    PhoneCallActivityExpandedBottomView()
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
