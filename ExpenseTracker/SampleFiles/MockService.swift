//
//  MockService.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 22/07/26.
//

import Foundation
class MockService {
    func searchPhotos(title: String) async -> [PhotoModel]? {
        print("🔵 Started search:", title)
        do {
            
            try await Task.sleep(for: .seconds(3))
            print("🟢 Finished search:", title)
            return [PhotoModel(id: "1", url: URL(string: "https://picsum.photos/v2/list") ?? URL(fileURLWithPath: ""), title: title)]
        } catch {
            print("🔴 Cancelled search:", title)
        }
        return nil
    }
}
