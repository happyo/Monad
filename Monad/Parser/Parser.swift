//
//  Parser.swift
//  Pods
//
//  Created by happyo on 2018/5/2.
//

import Foundation

public class Parser<A>: Alternative {
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
    
    public static func pure(_ a: A) -> Parser<A> {
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
    
    static func empty() -> Parser<A> {
        return Parser<A>({ _ in
            Optional.none
        })
    }
    
    public func alternative(_ fa: Parser<A>) -> Parser<A> {
        return Parser<A>({ s in
            if let just = self.runParser()(s) {
                return just
            } else {
                return fa.runParser()(s)
            }
        })
    }
    
    public static func returnM(_ a: A) -> Parser<A> {
        return self.pure(a)
    }
    
    public func flatten<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
        return Parser<B>({ s in
            if let (a, ss) = self.runParser()(s) {
                return f(a).runParser()(ss)
            } else {
                return Optional.none
            }
        })
    }
    
    // >>
    public func flattenIgnore<B>(_ b : Parser<B>) -> Parser<B> {
        return self.flatten({ _ in
            b
        })
    }
    
//    public func flattenLeft<B>(_ b : Parser<B>) -> Parser<A> {
//        return Parser<A>({ s in
//            if let (a, ss) = self.runParser()(s) {
//                if let (_, sss) = b.runParser()(ss) {
//                    return (a, sss)
//                } else {
//                    return Optional.none
//                }
//            } else {
//                return Optional.none
//            }
//        })
//    }
    
    public func many() -> Parser<[A]> {
        return self.some().alternative(Parser<[A]>.pure([]))
    }
    
    public func some() -> Parser<[A]> {
        return self.flatten({ p in
            self.many().fmap({ pl in
                return [p] + pl
            })
        })
    }
    
//    public func eof() -> Parser<A> {
//        return Parser<A>({ s in
//            if s.isEmpty {
//                return Optional.none
//            } else {
//                return self.runParser()(s)
//            }
//        })
//    }
}

public func satisfy(_ f : @escaping (Character) -> Bool) -> Parser<Character> {
    return Parser<Character>({ (s) -> Optional<(Character, String)> in
        if s.isEmpty {
            return Optional.none
        } else {
            if f(s.first!) {
                return Optional((s.first!, String(s.dropFirst())))
            } else {
                return Optional.none
            }
        }
    })
}

public func char(_ c : Character) -> Parser<Character> {
    return satisfy({ cc in
        c == cc
    })
}

public func noneOf(xs: String) -> Parser<Character>
{
    return satisfy { c in
        !xs.contains(c)
    }
}


public func eof<T>(_ a : T) -> Parser<T> {
    return Parser<T>({ s in
        if s.isEmpty {
            return Optional.none
        } else {
            return (a, s)
        }
    })
}
