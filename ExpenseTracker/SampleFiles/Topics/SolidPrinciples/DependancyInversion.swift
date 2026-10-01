//
//  DependancyInversion.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 01/10/26.
//

import Foundation

class SampleLowLevelViewModel {
    func getData() {
        
    }
}
class SampleHighLevelView {
    private let lowLevelModule: SampleLowLevelViewModel = SampleLowLevelViewModel()
    
    func showData() {
        lowLevelModule.getData()
    }
}

protocol LowLevelViewModelProtocol {
    func getData()
}

class OptimisedLowLevelViewModel : LowLevelViewModelProtocol {
    func getData() {
        print("optimised low level view model")
    }
}

class OptimisedHighLevelView {
    private let lowLevelModule: LowLevelViewModelProtocol
    
    init(lowLevelModule: LowLevelViewModelProtocol) {
        self.lowLevelModule = lowLevelModule
    }
    
    func showData() {
        lowLevelModule.getData()
    }
}
