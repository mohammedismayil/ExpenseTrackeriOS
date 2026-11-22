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
            do  {
                try startMatchActivity()
            } catch {
                print(error)
            }
        }.padding(.vertical, 20)
        
        
        Button("Start phone call") {
            do {
                let attributes = PhoneCallActivityAttributes()
                let activity = try Activity.request(attributes: attributes, content: .init(state: .init(callState: .hold), staleDate: .none), pushType: .none)
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
    
    func startMatchActivity() throws {
        let attrs = FootballScoreBoardActivityAttributes(matchID: "m123", teamA: "Arsenal", teamB: "Chelsea")
        let state = FootballScoreBoardActivityAttributes.ContentState(
            teamAScore: 0, teamBScore: 0, minute: 0, status: "LIVE")

        let activity = try Activity.request(
            attributes: attrs,
            content: .init(state: state, staleDate: nil),
            pushType: .none            // this enables remote updates
        )

        Task {
            // The token can change, so keep listening
            for await tokenData in activity.pushTokenUpdates {
                let token = tokenData.map { String(format: "%02x", $0) }.joined()
//                await api.registerLiveActivityToken(token, matchID: attrs.matchID)
            }
        }
    }
}

#Preview {
    GroupExample()
}
