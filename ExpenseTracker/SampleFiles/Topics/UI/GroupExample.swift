//
//  GroupExample.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 08/11/26.
//

import SwiftUI
import ActivityKit

struct GroupExample: View {
    var body: some View {
        Text("Header")
        Group {
            Text("Title")//.font(.caption)
            Text("description")
        }.font(.largeTitle)
        
        Button("Start scoreboard") {
            do {
                let attributes = FootballScoreBoardActivityAttributes()
                let activity = try Activity.request(attributes: attributes, content: .init(state: .init(teamA: "Chelsea", teamB: "Man UTD", teamAScore: 0, teamBScore: 0), staleDate: .none), pushType: .none)
            } catch {
                print(error)
            }
        }.padding(.vertical, 20)
        
        Button("Stop scoreboard") {
            Task {
                for activity in Activity<FootballScoreBoardActivityAttributes>.activities {
                    await activity.end(nil, dismissalPolicy: .default)
                }
            }
            
        }.padding(.vertical, 20)
        
        Button("Chelsea") {
            
        }
    }
    
    func activateFootballScoreBoard() {
        
    }
}

#Preview {
    GroupExample()
}
