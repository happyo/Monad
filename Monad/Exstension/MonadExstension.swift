//
//  MonadExstension.swift
//  Pods
//
//  Created by happyo on 2018/4/28.
//

import Foundation

extension Array: Functor {
    public typealias A = Element
    public typealias B = Any
    public typealias FA = Array<A>
    public typealias FB = Array<B>
    
    public func fmap<B>(_ f: @escaping (A) -> B) -> FB {
        return self.map(f)
    }
}

extension Optional: Functor {
    public typealias A = Wrapped
    public typealias B = Any
    public typealias FA = Optional<A>
    public typealias FB = Optional<B>
    
    public func fmap<B>(_ f: @escaping (A) -> B) -> FB {
        return self.map(f)
    }
}

extension Optional: Applicative {
    public typealias FF = Optional<(A) -> B>
    
    static func pure(_ a: Wrapped) -> Optional<Wrapped> {
        return Optional(a)
    }
    
    public func apply<B>(_ ff: Optional<(Wrapped) -> B>) -> Optional<B> {
        if let ffo = ff {
            return self.map(ffo)
        } else {
            return Optional<B>.none
        }
    }
}

extension Optional: Monad {
    static func returnM(_ a: Wrapped) -> Optional<Wrapped> {
        return self.pure(a);
    }
    
    public func flatten<B>(_ f: @escaping (Wrapped) -> Optional<B>) -> Optional<B> {
        return self.flatMap(f)
    }
}

extension String: Monoid {
    public static func mempty() -> String {
        return ""
    }
    
    public func mappend(_ a: String) -> String {
        return self + a
    }
}

extension Optional: Alternative {
    static func empty() -> Optional<Wrapped> {
        return Optional.none
    }
    
    public func alternative(_ fa: Optional<Wrapped>) -> Optional<Wrapped> {
        switch self {
        case .none:
            return fa
        default:
            return self
        }
    }
}
