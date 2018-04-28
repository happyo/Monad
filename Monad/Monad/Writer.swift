//
//  Writer.swift
//  Monad
//
//  Created by happyo on 2018/4/28.
//

import Foundation

public struct Writer<W, A>: Monad where W: Monoid{
    
    
    typealias B = Any
    typealias FA = Writer<W, A>
    typealias FB = Writer<W, B>
    typealias FF = Writer<W, (A) -> B>
    
    let runWriter : (A, W)
    
    init(_ writer : (A, W)) {
        self.runWriter = writer
    }

    func fmap<B>(_ f: @escaping (A) -> B) -> Writer<W, Writer.B> {
        let (a, w) = self.runWriter
        return Writer<W, Writer.B>((f(a), w))
    }
    
    static func pure(_ a: A) -> Writer<W, A> {
        return Writer<W, A>((a, W.mempty()))
    }
    
    public func apply<B>(_ ff: Writer<W, (A) -> B>) -> Writer<W, B> {
        let (a, w) = self.runWriter
        let (f, ww) = ff.runWriter
        return Writer<W, B>((f(a), w.mappend(ww)))
    }
    
    static func returnM(_ a: A) -> Writer<W, A> {
        return self.pure(a)
    }
    
    public func flatten<B>(_ f: @escaping (A) -> Writer<W, B>) -> Writer<W, B> {
        let (x, v) = self.runWriter
        let (y, vv) = f(x).runWriter
        return Writer<W, B>((y, v.mappend(vv)))
    }
}
