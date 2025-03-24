//
//  HistoryView.swift
//  TalkGlobal
//
//  Created by Biraj Dahal on 3/24/25.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var translationHistory = TranslationHistory()
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if translationHistory.translations.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "document.badge.clock.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No translations yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Your translations will appear here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(translationHistory.translations) { translation in
                            MessageRow(
                                translation: translation,
                                onDelete: { id in
                                    translationHistory.deleteOneRecord(id: id)
                                }
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                    
    
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear All")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                        .padding()
                    }
                    .alert("Clear History", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Clear", role: .destructive) {
                            translationHistory.deleteAllHistory()
                        }
                    } message: {
                        Text("Are you sure you want to clear all translation history?")
                    }
                }
            }
            .onAppear {
                translationHistory.getHistory()
            }
        }
    }
}

struct MessageRow: View {
    let translation: Translation
    let onDelete: (String) -> Void
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: translation.timestamp)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(translation.source)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(4)
                            
                            Spacer()
                            
                            Text(formattedDate)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(translation.originalText)
                            .font(.subheadline)
                            .padding(.top, 2)
                    }
                    
                    HStack {
                        Image(systemName: "arrow.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(translation.target)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                        
                        Text(translation.translatedText)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.top, 2)
                    }
                }
                
                Button(action: {
                    onDelete(translation.id)
                }) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.8))
                        .padding(6)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    HistoryView()
}
