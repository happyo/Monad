//
//  Reader.swift
//  Pods
//
//  Created by happyo on 2018/4/28.
//

import Foundation

public class Reader<R, A>: Monad {
    typealias B = Any
    typealias FA = Reader<R, A>
    typealias FB = Reader<R, B>
    typealias FF = Reader<R, (A) -> B>
    
    let reader: (R) -> A
    
    public init(_ reader: @escaping (R) -> A) {
        self.reader = reader
    }
    
    public func runReader() -> (R) -> A {
        return self.reader
    }
    
    func fmap<B>(_ f: @escaping (A) -> B) -> Reader<R, Reader.B> {
        return Reader<R, Reader.B>({ (r) -> B in
            f(self.runReader()(r))
        })
    }
    
    static func pure(_ a: A) -> Reader<R, A> {
        return Reader<R, A>({ (r) -> A in
            a
        })
    }
    
    func apply(_ ff: Reader<R, (A) -> Reader.B>) -> Reader<R, Reader.B> {
        return Reader<R, Reader.B>({ (r) -> B in
            let a = self.reader(r)
            let f = ff.runReader()(r)
            return f(a)
        })
    }
    
    static func returnM(_ a: A) -> Reader<R, A> {
        return self.pure(a)
    }
    
    public func flatten<B>(_ f: @escaping (A) -> Reader<R, B>) -> Reader<R, B> {
        return Reader<R, B>({ (r) -> B in
            let a = self.runReader()(r)
            return f(a).runReader()(r)
        })
    }
}
