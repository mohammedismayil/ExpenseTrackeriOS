//
//  Appdelegate.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 11/08/26.
//

import Foundation
import UIKit
class Appdelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        print("Background session: \(identifier)")
        ResumableDownloader.shared.backgroundCompletionHandler = completionHandler
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        print("application did finish launching")

        return true
    }
}
