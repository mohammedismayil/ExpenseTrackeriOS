//
//  Actors.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 03/08/26.
//

import Foundation
import UIKit

class CounterClass {
    var count = 0
    
    func increment(){
        count += 1
    }
}

actor CounterActor {
    var count = 0
    
    func increment(){
        count += 1
    }
}

actor ImageCache {
    private var images: [URL: UIImage] = [:]
    
    func insert(url: URL, image: UIImage) {
        images[url] = image
    }
    
    func image(url: URL) -> UIImage? {
        return images[url]
    }
    
    func remove(url: URL) {
        images.removeValue(forKey: url)
    }
    
    func clear() {
        images = [:]
    }
}
