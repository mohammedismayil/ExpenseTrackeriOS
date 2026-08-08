//
//  Generics.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 08/08/26.
//

protocol AnimalFood {
    var name: String { get }
    associatedtype cropType: Crop where cropType.Feed == Self
    func grow() -> cropType
}

protocol Crop {
    associatedtype Feed: AnimalFood
    func harvest() -> Feed
}
protocol Animal {
    associatedtype Food: AnimalFood
    func eat(food: Food)
}
struct FishFood: AnimalFood {
    
    let name = "Fishfood"
    
    func grow() -> FishCrop {
        FishCrop()
    }
}

struct CowFood: AnimalFood {
    
    let name = "CowFood"
    
    func grow() -> CowCrop {
        CowCrop()
    }
}
struct CowCrop: Crop {
    func harvest() -> CowFood {
        CowFood()
    }
}
struct FishCrop: Crop {
    func harvest() -> FishFood {
        FishFood()
    }
}

struct Farm {
    func feed<A: Animal>(animal: A, food: A.Food) {
        animal.eat(food: food)
    }
}

struct Fish: Animal {
    func eat(food: FishFood) {
        print("Fish is eating \(food)")
    }
}

//
//struct Cow : Animal {
//    func eat(food: CowFood) {
//        print("Iam aeating cowfood")
//    }
//}

//struct Lion : Animal {
//    func eat(food: CowFood) {
//        print("Iam aeating meat")
//    }
//}

class GenericsDemo {
    func test() {
//        
        let farm = Farm()
        let fish = Fish()
        fish.eat(food: FishFood())
//        let lion = Lion()
//        
//        farm.feed(animal: lion, with: CowFood())
//        
//        farm.feed(animal: cow, with: CowFood())
    }
}


