//
//  FootballScoreBoardActivity.swift
//  ExpenseTrackerWidgetExtension
//
//  Created by Mohammed Ismayil on 21/11/26.
//

import Foundation
import WidgetKit

import ActivityKit
import SwiftUI

struct FootballScoreBoardActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FootballScoreBoardActivityAttributes.self) { context in
            FootballScoreBoardLockScreenView(dataModel: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        VStack {
                            Image(systemName: "heart.fill").frame(width: 30,height: 30)
                            Text(context.attributes.teamA)
                        }
                        VStack(alignment: .center) {
                            Text("\(context.state.teamAScore) - \(context.state.teamBScore)")
                        }
                        VStack {
                            Image(systemName: "heart.fill").frame(width: 30,height: 30)
                            Text(context.attributes.teamB)
                        }
                    }
                }
            } compactLeading: {
                HStack {
                    Circle().fill(.red).frame(width: 20, height: 20)
                    Text("Arsenal")
                }
            } compactTrailing: {
                Text("2 - 1").font(.system(size: 18, weight: .bold))
            } minimal: {
                Text("2 - 1").font(.system(size: 18, weight: .bold))
            }

        }

    }
}

struct FootballScoreBoardActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var teamAScore: Int
        var teamBScore: Int
        var minute: Int
        var status: String          // "LIVE", "HT", "FT"
    }
    // Static for the whole activity
    let matchID: String
    let teamA: String
    let teamB: String
}


struct FootballScoreBoardLockScreenView: View {
    let dataModel: ActivityViewContext<FootballScoreBoardActivityAttributes>
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(dataModel.attributes.teamA)
                Text("\(dataModel.state.teamAScore) - \(dataModel.state.teamBScore)")
                    .font(.system(size: 28, weight: .bold))
                    .contentTransition(.numericText())
                Text(dataModel.attributes.teamB)
            }
            HStack {
                Circle().fill(.green).frame(width: 10, height: 10)
                Text(dataModel.state.status).bold()
                Text("\(dataModel.state.minute)'")
            }
        }
        .padding(.vertical, 15)
    }
}
