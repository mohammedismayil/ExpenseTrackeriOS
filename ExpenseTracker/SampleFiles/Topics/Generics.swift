//
//  Generics.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 08/08/26.
//

protocol AnimalFood {
    var name: String { get }
}
protocol Animal {
    associatedtype food: AnimalFood
    func eat(food: food)
}
struct FishFood: AnimalFood {
    let name = "Fishfood"
}

struct CowFood: AnimalFood {
    let name = "Grass"
}

struct Farm {
    func feed<A: Animal>(animal: A, with food: A.food) {
        animal.eat(food: food)
    }
}


struct Cow : Animal {
    func eat(food: CowFood) {
        print("Iam aeating cowfood")
    }
}

class GenericsDemo {
    func test() {
        
        let farm = Farm()
        let cow = Cow()
        
        farm.feed(animal: cow, with: CowFood())
    }
}


