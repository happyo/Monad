//
//  State.swift
//  Pods
//
//  Created by happyo on 2018/4/28.
//

import Foundation

public class State<S, A>: Monad {
    typealias B = Any
    typealias FA = State<S, A>
    typealias FB = State<S, B>
    typealias FF = State<S, (A) -> B>
    
    private let state : (S) -> (A, S)
    
    public init(_ state : @escaping (S) -> (A, S)) {
        self.state = state
    }
    
    public func runState() -> (S) -> (A, S) {
        return self.state
    }
    
    func fmap<B>(_ f: @escaping (A) -> B) -> State<S, State.B> {
        return State<S, State.B>({ (s) -> (B, S) in
            let (a, ss) = self.state(s)
            return (f(a), ss)
        })
    }
    
    static func pure(_ a: A) -> State<S, A> {
        return State<S, A>({ (s) -> (A, S) in
            (a, s)
        })
    }
    
    func apply(_ ff: State<S, (A) -> State.B>) -> State<S, State.B> {
        return State<S, State.B>({ (s) -> (B, S) in
            let (a, ss) = self.state(s)
            let (f, sss) = ff.state(ss)
            return (f(a), sss)
        })
    }
    
    static func returnM(_ a: A) -> State<S, A> {
        return self.pure(a)
    }
    
    public func flatten<B>(_ f: @escaping (A) -> State<S, B>) -> State<S, B> {
        return State<S, B>({ (s) -> (B, S) in
            let (a, ss) = self.state(s)
            let (k, sss) = f(a).state(ss)
            return (k, sss)
        })
    }
}
