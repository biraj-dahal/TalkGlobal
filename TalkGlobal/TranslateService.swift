//
//  TranslateService.swift
//  TalkGlobal
//
//  Created by Biraj Dahal on 3/23/25.
//

import Foundation

@Observable
class TranslateService: ObservableObject {
    static let possible_languages: [String: String] = [
        "Ukrainian": "UK",
        "Turkish": "TR",
        "Swedish": "SV",
        "Spanish": "ES",
        "Slovenian": "SL",
        "Slovak": "SK",
        "Russian": "RU",
        "Romanian": "RO",
        "Portuguese": "PT",
        "Polish": "PL",
        "Norwegian Bokmål": "NB",
        "Lithuanian": "LT",
        "Latvian": "LV",
        "Korean": "KO",
        "Japanese": "JA",
        "Italian": "IT",
        "Indonesian": "ID",
        "Hungarian": "HU",
        "Greek": "EL",
        "German": "DE",
        "French": "FR",
        "Finnish": "FI",
        "Estonian": "ET",
        "English": "EN",
        "Dutch": "NL",
        "Danish": "DA",
        "Czech": "CS",
        "Chinese": "ZH",
        "Bulgarian": "BG",
        "Arabic": "AR"
    ]
    
    func getAPIKey() -> String? {
        return ProcessInfo.processInfo.environment["DEEPL_API_KEY"]
    }
    
    func translateText(text: String, targetLang: String) async throws -> String? {
        guard let apiKey = getAPIKey() else {
            print("API Key is missing.")
            return nil
        }

        let url = URL(string: "https://api-free.deepl.com/v2/translate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")

        let requestBody = DeepLTranslationRequest(text: [text], target_lang: targetLang)
        request.httpBody = try JSONEncoder().encode(requestBody)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(DeepLTranslationResponse.self, from: data)
            return decodedResponse.translations.first?.text
        } catch {
            print("Translation Error: \(error.localizedDescription)")
            return nil
        }
    }
}
