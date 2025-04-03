    //
    //  SymbolGridView.swift
    //  SFSymbols App
    //
    //  Created by Mitul Pokiya on 03/04/25.
    //

import SwiftUI

struct SymbolGridView: View {

    @StateObject private var vm = SymbolGridViewModel()

    let columns = [GridItem(.adaptive(minimum: 85))] // Adjust grid size
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(vm.filteredSymbols, id: \.self) { symbol in
                        NavigationLink(destination: SymbolDetailView(symbol: symbol, vm: vm)) {
                            VStack(spacing: 10) {
                                Image(systemName: symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .symbolRenderingMode(vm.renderingMode)
                                    .foregroundStyle(vm.selectedColor)
                                Text(symbol)
                                    .font(.caption)
                                    .lineLimit(4)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 88, height: 120)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }.buttonStyle(.plain)
            }.padding([.leading, .trailing], 10)
                .navigationTitle("SF Symbols")
                .searchable(text: $vm.searchText, prompt: "Search Symbols") // 🔍 Adds search bar
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Section("Symbol Rendering Mode") {
                                Button("Hierarchical") {  vm.updateRenderingMode(to: .hierarchical) }
                                Button("Monochrome") {  vm.updateRenderingMode(to: .monochrome) }
                                Button("Multicolor") { vm.updateRenderingMode(to: .multicolor) }
                                Button("Palette") { vm.updateRenderingMode(to: .palette) }
                            }
                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                        }
                    }
                }
        }
    }
    
}


#Preview {
    SymbolGridView()
}
