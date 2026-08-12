//
//  PropertyObserverExample.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 12/08/26.
//

import Foundation
import UIKit
import SwiftUI

class PropertyObserverExample: UIViewController {
    var score: Int = 0 {
        didSet {
            print(oldValue)
            setCurrentScore()
        }
        willSet {
            print(newValue)
        }
    }
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("increase", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        
        self.view.addSubview(scoreLabel)
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            scoreLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            scoreLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            button.leadingAnchor.constraint(equalTo: self.scoreLabel.leadingAnchor),
            button.topAnchor.constraint(equalTo: self.scoreLabel.bottomAnchor, constant: 100),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.setCurrentScore()
        
    }
    
    @objc func buttonAction() {
        score += 1
    }
    
    func setCurrentScore() {
        scoreLabel.text = "Your score: \(score)"
    }
}

struct PropertyObserverExampleView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return PropertyObserverExample()
    }
}
