//
//  Translation.swift
//  TalkGlobal
//
//  Created by Biraj Dahal on 3/24/25.
//

import Foundation

struct Translation: Hashable, Identifiable, Codable {
    var id: String 
    let timestamp: Date
    let translatedText: String
    let originalText: String
    let source: String
    let target: String
    
    
}
