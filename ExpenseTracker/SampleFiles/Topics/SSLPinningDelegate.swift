//
//  SSLPinningDelegate.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 11/08/26.
//

import Foundation

class SSLPinningDelegate: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let trust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard let serverCertificate = SecTrustGetCertificateAtIndex(trust,0) else {
            return
        }
        
        let serverData = SecCertificateCopyData(serverCertificate) as Data
        let pinnedData = Data() // from bundle.main
        
        if serverData == pinnedData {
            print("SSL Pinning success")
            completionHandler(.useCredential, URLCredential(trust: trust))
        }
        
    }
}
