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
                            Text(context.state.teamA)
                        }
                        VStack(alignment: .center) {
                            Text("\(context.state.teamAScore) - \(context.state.teamBScore)")
                        }
                        VStack {
                            Image(systemName: "heart.fill").frame(width: 30,height: 30)
                            Text(context.state.teamB)
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
    typealias ContentState = FootballScoreBoardModel
    
    struct FootballScoreBoardModel: Codable, Hashable {
        let teamA: String
        let teamB: String
        
        var teamAScore: Int
        var teamBScore: Int
        
    }
    
}


struct FootballScoreBoardLockScreenView: View {
    let dataModel: ActivityViewContext<FootballScoreBoardActivityAttributes>
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center) {
                VStack(spacing: 2
                       , content: {
                    Text("Arsenal")
                    Circle().fill(.red).frame(width: 15, height: 15)
                })
                VStack(spacing: 2
                       , content: {
                    Text("Chelsea")
                    Circle().fill(.blue).frame(width: 15, height: 15)
                })
            }
            
            HStack {
                Text("2 - 1").font(.system(size: 28, weight: .bold))
            }
            
            HStack {
                Circle().fill(.green).frame(width: 10, height: 10)
                Text("LIVE").font(.system(size: 15, weight: .bold))
                Text("72.18").font(.system(size: 13, weight: .light))
            }
        }.padding(.vertical,15)
    }
}
