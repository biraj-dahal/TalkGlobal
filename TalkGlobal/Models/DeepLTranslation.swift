//
//  DeepLTranslation.swift
//  TalkGlobal
//
//  Created by Biraj Dahal on 3/23/25.
//

import Foundation


struct DeepLTranslationRequest: Codable {
    let text: [String]
    let target_lang: String
}


struct DeepLTranslationResponse: Codable {
    let translations: [Translation]

    struct Translation: Codable {
        let text: String
    }
}


