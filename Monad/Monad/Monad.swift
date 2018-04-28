//
//  Monad.swift
//  FunctionalDemo
//
//  Created by happyo on 2018/4/20.
//  Copyright © 2018年 happyo. All rights reserved.
//

import Foundation

public protocol Monoid {
    associatedtype A
    func mempty() -> A
    func mappend(_ a : A) -> A
}

protocol Functor {
    associatedtype A
    associatedtype B
    associatedtype FA
    associatedtype FB
    
    func fmap<B>(_ f : @escaping (A) -> B) -> FB
}

protocol Applicative: Functor {
    associatedtype FF
    
    static func pure(_ a : A) -> FA
    func apply(_ ff : FF) -> FB
}

protocol Monad: Applicative {
    static func returnM(_ a : A) -> FA
    func flatten(_ f : @escaping (A) -> FB) -> FB
}