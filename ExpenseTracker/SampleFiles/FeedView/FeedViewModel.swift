//
//  FeedViewModel.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 23/07/26.
//

import Foundation
import Combine

@MainActor
class FeedViewModel: ObservableObject {

    @Published var feeds: [FeedCellModel] = []

    func fetchFeeds() async -> [FeedItem]? {
        print("📄 Fetching feed list...")
        do {
            try await Task.sleep(for: .seconds(1))

            print("✅ Feed list fetched")

            return [
                FeedItem(id: 1, userId: 1, imageId: 1),
                FeedItem(id: 2, userId: 2, imageId: 2),
                FeedItem(id: 3, userId: 3, imageId: 3),
                FeedItem(id: 4, userId: 4, imageId: 4)
            ]
        } catch {
            print("❌ Feed fetch cancelled")
            return nil
        }
    }

    func fetchUser(id: Int) async -> FeedUser? {

        print("👤 Start User \(id)")

        do {
            try await Task.sleep(for: .seconds(2))

            print("✅ User \(id) Ready")

            return FeedUser(id: id, name: "User \(Double(5-id))")
        } catch {
            print("❌ User \(id) Cancelled")
            return nil
        }
    }

    func fetchImage(id: Int) async -> FeedImage? {

        print("🖼️ Start Image \(id)")

        do {
            try await Task.sleep(for: .seconds(Double(5-id)))

            print("✅ Image \(id) Ready")

            return FeedImage(
                id: id,
                url: URL(string: "https://picsum.photos/200?random=\(id)")!
            )
        } catch {
            print("❌ Image \(id) Cancelled")
            return nil
        }
    }

    func loadFeed() async {

        print("")
        print("====================================")
        print("🚀 loadFeed Started")
        print("====================================")

        guard let feedItems = await fetchFeeds() else {
            return
        }

        print("📦 Creating \(feedItems.count) child tasks")

        await withTaskGroup(of: FeedCellModel?.self) { group in

            for item in feedItems {

                group.addTask {

                    print("🔵 Child Task Started -> Feed \(item.id)")

                    async let user = self.fetchUser(id: item.userId)
                    async let image = self.fetchImage(id: item.imageId)

                    guard
                        let user = await user,
                        let image = await image
                    else {
                        print("❌ Feed \(item.id) Failed")
                        return nil
                    }

                    print("🟢 FeedCellModel Created -> Feed \(item.id)")

                    return FeedCellModel(
                        id: item.id,
                        user: user,
                        image: image
                    )
                }
            }

            print("⏳ Parent waiting for completed child tasks...\n")

            for await feed in group {

                guard let feed else { continue }

                print("📥 Parent received Feed \(feed.id)")

                feeds.append(feed)

                print("📱 UI Updated (Total feeds: \(feeds.count))")
            }
        }

        print("")
        print("🎉 All child tasks completed")
        print("====================================")
    }
}

struct FeedItem {
    let id: Int
    let userId: Int
    let imageId: Int
}

struct FeedUser {
    let id: Int
    let name: String
}

struct FeedImage {
    let id: Int
    let url: URL
}

struct FeedCellModel: Identifiable {
    let id: Int
    let user: FeedUser
    let image: FeedImage
}
