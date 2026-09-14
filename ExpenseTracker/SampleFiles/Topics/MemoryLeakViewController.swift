//
//  MemoryLeakViewController.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 14/09/26.
//

import UIKit
import SwiftUI


class MemoryLeakViewController: UIViewController {
    
    var nextButton: UIButton  = {
        let button = UIButton(type: .system)
            button.setTitle("Tap Me", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 8
        return button
    } ()
    
    var closure: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(nextButton)
        nextButton.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        closure = {
//            self.view.backgroundColor = .red
        }
    }
}


struct MemoryLeakViewRepresentable: UIViewControllerRepresentable {
    
    
    
    func makeUIViewController(context: Context) -> MemoryLeakViewController {
        let viewController = MemoryLeakViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MemoryLeakViewController, context: Context) {
    }
}
