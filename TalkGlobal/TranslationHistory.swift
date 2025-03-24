//
//  TranslationHistory.swift
//  TalkGlobal
//
//  Created by Biraj Dahal on 3/24/25.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
class TranslationHistory: ObservableObject {
    @Published var translations: [Translation] = []

    private let dataBase = Firestore.firestore()


    func getHistory() {
        Task {
            do {
                let querySnapshot = try await dataBase.collection("translations").order(by: "timestamp", descending: true).getDocuments()
                
                let fetchedTranslations = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Translation.self)
                }
                
                self.translations = fetchedTranslations
            } catch {
                print("Error fetching documents: \(error.localizedDescription)")
            }
        }
    }

    func setTranslations(original: String, translated: String, target: String, source: String = "English") {
        let translation = Translation(id: UUID().uuidString, timestamp: Date(), translatedText: translated, originalText: original, source: source, target: target)
        do {
            try dataBase.collection("translations").document(translation.id).setData(from: translation)
        } catch {
            print("Error setting up.")
        }
        
        
    }

    func deleteAllHistory() {
        Task {
            do {
                let querySnapshot = try await dataBase.collection("translations").getDocuments()
                for document in querySnapshot.documents {
                    try await document.reference.delete()
                }
                self.translations.removeAll()
            } catch {
                print("Error removing documents: \(error.localizedDescription)")
            }
        }
    }

    func deleteOneRecord(id: String) {
        Task {
            do {
                let querySnapshot = try await dataBase.collection("translations")
                    .whereField("id", isEqualTo: id)
                    .getDocuments()

                for document in querySnapshot.documents {
                    try await document.reference.delete()
                }


                if let index = translations.firstIndex(where: { $0.id == id }) {
                    translations.remove(at: index)
                }
            } catch {
                print("Error deleting record: \(error.localizedDescription)")
            }
        }
    }

}
