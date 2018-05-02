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
        
        print(moveLeftTwice(2).runWriter())
        
        print(readLen().runReader()(Array("123123")))
        
    print(Optional.none.alternative(Optional.none).alternative(Optional(2)).alternative(Optional.none)!)
        
        print(Optional<Int>.none.many())
        
        print(satisfy(isDigit).many().runParser()("123abc"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

func isDigit(_ c : Character) -> Bool {
    if "0"..."9" ~= c {
        return true
    } else {
        return false
    }
}

func readLen() -> Reader<Array<Any>, Int> {
    return Reader<Array<Any>, Int>({ (xs: Array) -> Int in
        return xs.count
    })
}

func moveLeftTwice(_ a : Int) -> Writer<String, Int> {
    return left(a).flatten({ a1 in
        left(a1)
    })
}

func left(_ a : Int) -> Writer<String, Int> {
    return Writer<String, Int>((a - 1, "move left \n"))
}

func right(_ a : Int) -> Writer<String, Int> {
    return Writer<String, Int>((a + 1, "move right \n"))
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
    
    required init(_ value : Double) {
        self.value = value
    }
    
    static func mempty() -> Self {
        return self.init(1)
    }
    
    func mappend(_ a: Product) -> Self {
        let result = type(of: self).init(value * a.value)
        return result
    }
}

