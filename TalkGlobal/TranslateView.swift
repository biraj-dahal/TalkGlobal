//
//  TranslateView.swift
//  TalkGlobal
//
//  Created by Biraj Dahal on 3/23/25.
//

import SwiftUI

struct TranslateView: View {
    let languages = TranslateService.possible_languages
    @State private var selected_language_code: String = ""
    @State private var selected_language: String = ""
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    
    @State private var isLanguageValid: Bool = true
    @State private var isTextValid: Bool = true
    @State private var isTranslating: Bool = false
    
    @StateObject private var translateService = TranslateService()
    @StateObject private var translationHistory = TranslationHistory()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Language selection
                    HStack(spacing: 12) {
                        Text("English")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray)
                        
                        Menu {
                            ForEach(languages.keys.sorted(), id: \.self) { key in
                                Button(key) {
                                    selected_language_code = languages[key] ?? ""
                                    selected_language = key
                                    isLanguageValid = true
                                }
                            }
                        } label: {
                            HStack {
                                Text(selected_language.isEmpty ? "Select" : selected_language)
                                    .foregroundColor(isLanguageValid ? .primary : .red)
                                    .font(.headline)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Original Text")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                        
                        TextEditor(text: $inputText)
                            .frame(minHeight: 100)
                            .padding(10)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isTextValid ? Color.clear : Color.red, lineWidth: 1)
                            )
                            .onChange(of: inputText) { oldValue, newValue in
                                isTextValid = true
                            }
                        
                    }
                    Button {
                        isTextValid = !inputText.isEmpty
                        isLanguageValid = !selected_language.isEmpty
                        
                        if isTextValid && isLanguageValid {
                            isTranslating = true
                            
                            Task {
                                do {
                                    if let translation = try await translateService.translateText(text: inputText, targetLang: selected_language_code) {
                                        translatedText = translation
                                        translationHistory.setTranslations(original: inputText, translated: translatedText, target: selected_language)
                                    }
                                    isTranslating = false
                                } catch {
                                    print("Error during translation: \(error.localizedDescription)")
                                    isTranslating = false
                                }
                            }
                        }
                    } label: {
                        HStack {
                            if isTranslating {
                                ProgressView()
                                    .tint(.white)
                                    .padding(.trailing, 8)
                            }
                            Text("Translate")
                                .fontWeight(.medium)
                        }
                        .frame(minWidth: 120)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isTranslating)
                    
                    if !translatedText.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Translation")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.leading, 4)
                            
                            Text(translatedText)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: HistoryView()) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("Translation History")
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .navigationTitle("TalkGlobal")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
#Preview {
    TranslateView()
}
