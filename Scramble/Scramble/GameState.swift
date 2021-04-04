//
//  GameState.swift
//  Scramble
//
//  Created by Татьяна Овсянникова on 04.04.2021.
//

import Foundation

struct GameState: Codable {
    var currentWord: String
    var usedWords: [String]
}
