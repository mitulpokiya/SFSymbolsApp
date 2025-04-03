    //
    //  SymbolGridViewModel.swift
    //  SFSymbols App
    //
    //  Created by Mitul Pokiya on 03/04/25.
    //

import SwiftUI

@MainActor
final class SymbolGridViewModel: ObservableObject {

    @Published var allSymbols: [String] = []
    @Published var searchText: String = ""   // Holds search input
    @Published var renderingMode: SymbolRenderingMode = .hierarchical // Default mode
    @Published var selectedColor: Color = .black // Default color
    @Published var symbolSize: CGFloat = 120

    init() {
        fetchAllSFSymbols()
    }

        /// Fetches all SF Symbols from the system
    private func fetchAllSFSymbols() {
        guard let sfSymbolsBundle = Bundle(identifier: "com.apple.SFSymbolsFramework"),
              let bundlePath = sfSymbolsBundle.path(forResource: "CoreGlyphs", ofType: "bundle"),
              let bundle = Bundle(path: bundlePath),
              let resourcePath = bundle.path(forResource: "symbol_search", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: resourcePath) else {
            print("❌ Failed to load SF Symbols")
            return
        }

        let symbolNames = plist.allKeys.compactMap { $0 as? String }
        allSymbols = symbolNames.sorted() // Sort for better UI experience
    }
    
        /// Returns filtered symbols based on search query
    var filteredSymbols: [String] {
        searchText.isEmpty ? allSymbols :
        allSymbols.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

        /// Updates the rendering mode
    func updateRenderingMode(to mode: SymbolRenderingMode) {
        renderingMode = mode
    }
}
