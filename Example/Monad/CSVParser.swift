//
//  CSVParser.swift
//  Monad_Example
//
//  Created by happyo on 2018/5/3.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import Monad

func csvFile() -> Parser<[[String]]> {
    return line().many()
}

func line() -> Parser<[String]> {
    return cells().flatten({ result in
        eol().flatten({ _ in
            Parser<[String]>.returnM(result)
        })
    })
}

func cells() -> Parser<[String]> {
    return cellContent().flatten({ first in
        remainingCells().flatten({ next in
            Parser.returnM([first] + next)
            })
    })
}

func remainingCells() -> Parser<[String]> {
    return char(",").flattenIgnore(cells()).alternative(Parser.pure([]))
}

func eol() -> Parser<Character> {
    return char("\n")
}

func cellContent() -> Parser<String> {
    return noneOf(xs: ",\n").many().fmap({ s in
        String(s)
    })
}
