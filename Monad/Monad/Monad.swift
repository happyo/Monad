//
//  Monad.swift
//  FunctionalDemo
//
//  Created by happyo on 2018/4/20.
//  Copyright © 2018年 happyo. All rights reserved.
//

import Foundation

public protocol Monoid {
    static func mempty() -> Self
    func mappend(_ a : Self) -> Self
}

protocol Functor {
    associatedtype A
    associatedtype B
    associatedtype FA
    associatedtype FB
    
    func fmap(_ f : @escaping (A) -> B) -> FB
}

protocol Applicative: Functor {
    associatedtype FF
    
    static func pure(_ a : A) -> FA
    
    // same ap in Haskell
    func apply(_ ff : FF) -> FB
}

protocol Monad: Applicative {
    static func returnM(_ a : A) -> FA
    
    // same >>= in Haskell
    func flatten(_ f : @escaping (A) -> FB) -> FB
}

protocol Alternative: Monad {
    // f a
    associatedtype FA
    // f [a]
    associatedtype FAL
    
    static func empty() -> FA
    
    // same <|> in Haskell
    func alternative(_ fa: FA) -> FA
    
    func some() -> FAL
    func many() -> FAL
}

