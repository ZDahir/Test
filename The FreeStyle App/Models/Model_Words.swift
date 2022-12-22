//
//  Model_Words.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 26/07/2022.
//  Copyright © 2022 Zaid Dahir. All rights reserved.
//

import Foundation


// MARK: - Words
struct Words: Codable {
    var word: String?
    var score: Int?
    var numSyllables: Int?

    enum CodingKeys: String, CodingKey {
        case word = "word"
        case score = "score"
        case numSyllables = "numSyllables"
        
    }
}
