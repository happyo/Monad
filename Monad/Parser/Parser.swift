//
//  Parser.swift
//  Pods
//
//  Created by happyo on 2018/5/2.
//

import Foundation

class Parser<A>: Alternative {
    typealias B = Any
    typealias FA = Parser<A>
    typealias FB = Parser<B>
    typealias FF = Parser<(A) -> B>
    
    private let parser: (String) -> Optional<(A, String)>
    
    init(_ parser : @escaping (String) -> Optional<(A, String)>) {
        self.parser = parser
    }
    
    public func runParser() -> (String) -> Optional<(A, String)> {
        return parser
    }
    
    public func fmap<B>(_ f: @escaping (A) -> B) -> Parser<B> {
        return Parser<B>({ (s) -> Optional<(B, String)> in
            if let (a, ss) = self.runParser()(s) {
                return Optional((f(a), ss))
            } else {
                return Optional.none
            }
        })
    }
    
    static func pure(_ a: A) -> Parser<A> {
        return Parser<A>({ (s) -> Optional<(A, String)> in
            Optional((a, s))
        })
    }
    
    public func apply<B>(_ ff: Parser<(A) -> B>) -> Parser<B> {
        return Parser<B>({ (s) -> Optional<(B, String)> in
            if let (a, ss) = self.runParser()(s) {
                if let (f, sss) = ff.runParser()(ss) {
                    return (f(a), sss)
                } else {
                    return Optional.none
                }
            } else {
                return Optional.none
            }
        })
    }
    
    public func empty() -> Parser<A> {
        return Parser<A>({ _ in
            Optional.none
        })
    }
    
    public func alternative(_ fa: Parser<A>) -> Parser<A> {
        return Parser<A>({ s in
            if let just = self.runParser()(s) {
                return just
            } else {
                return Optional.none
            }
        })
    }
    
    static func returnM(_ a: A) -> Parser<A> {
        return self.pure(a)
    }
    
    public func flatten<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
        return Parser<B>({ s in
            if let (a, ss) = self.runParser()(s) {
                if let just = f(a).runParser()(ss) {
                    return just
                } else {
                    return Optional.none
                }
            } else {
                return Optional.none
            }
        })
    }
    
    public func many() -> Parser<[A]> {
        return self.some().alternative(Parser<[A]>.pure([]))
    }
    
    public func some() -> Parser<[A]> {
        return self.flatten({ p in
            self.many().flatten({ pl in
                return pl + [p]
            })
        })
    }
}
