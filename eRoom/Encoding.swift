//
//  Encoding.swift
//  Encoding
//
//  Created by Devran Uenal on 5.12.16.
//  Copyright © 2016 Devran Uenal. All rights reserved.
//

import Foundation

public extension String {
    public init?<S : Sequence>(bytes: S, iso8859Encoding: ISO8859) where S.Iterator.Element == UInt8 {
        var convertionTable: [UInt8: Int]
        convertionTable = CharacterCodingMap.part8
        
        let characters = bytes.flatMap{ convertionTable[$0] }.flatMap({ UnicodeScalar($0) }).flatMap({ Character($0) })
        self.init(characters)
    }
}
