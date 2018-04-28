//
//  ViewController.swift
//  Monad
//
//  Created by happyo on 04/28/2018.
//  Copyright (c) 2018 happyo. All rights reserved.
//

import UIKit
import Monad

typealias Stack = [Int]

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(Product(1).mappend(Product(2)).value)
        print([1, 2, 3].fmap({ a in
            String(a)
        }))
        print(Optional(1).flatten({ a in
            String(a)
        }).flatten({ s in
            Int(s)
        })!)

        print(Optional(1).apply(Optional(addOne))!)

        print(addStackOne().runState()([5,6]))

        print(pop().flatten({ a in
            return pop()
        }).runState()([1,2,3]))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

func pop() -> State<Stack, Int> {
    return State<Stack, Int>({ (s) -> (Int, Stack) in
        (s.first!, Array(s.dropFirst()))
    })
}

func push(_ x : Int) -> State<Stack, Void> {
    return State<Stack, Void>({ (s) -> (Void, Stack) in
        var array = Array(s)
        array.append(x)
        return ((), array)
    })
}

func addStack() -> State<Stack, Void> {
    return State<Stack, Void>({ (s) -> ((), Stack) in
        let (a1, ss) = pop().runState()(s)
        let (a2, sss) = pop().runState()(ss)

        return push(a1 + a2).runState()(sss)
    })
}

func popTwice() -> State<Stack, Int> {
    return pop().flatten({ _ in
        pop()
    })
}

func addStackOne() -> State<Stack, Void> {
    return pop().flatten({ a in
        pop().flatten({ b in
            push(a + b)
        })
    })
}

func addOne(_ n : Int) -> Int {
    return n + 1
}

class Product: Monoid {
    var value: Double
    
    init(_ value : Double) {
        self.value = value
    }
    typealias A = Product
    
    func mempty() -> Product.A {
        return Product(1)
    }
    
    func mappend(_ a: Product) -> Product {
        return Product(self.value * a.value)
    }
}
