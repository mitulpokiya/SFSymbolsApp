    //
    //  SymbolDetailView.swift
    //  SFSymbols App
    //
    //  Created by Mitul Pokiya on 03/04/25.
    //

import SwiftUI

struct SymbolDetailView: View {
    let symbol: String
    @State private var showAlert = false
    @ObservedObject var vm: SymbolGridViewModel

    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Button {
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: vm.symbolSize, height: vm.symbolSize))
                    let image = renderer.image { _ in
                        let uiImage = UIImage(systemName: symbol)?.withTintColor(UIColor(vm.selectedColor))
                        uiImage?.draw(in: CGRect(x: 0, y: 0, width: vm.symbolSize, height: vm.symbolSize))
                    }

                    if let pngData = image.pngData() {
                        UIPasteboard.general.setData(pngData, forPasteboardType: "public.png")
                        showAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showAlert = false
                        }
                    }


                } label: {
                    Image(systemName: symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: vm.symbolSize, height: vm.symbolSize)
                        .symbolRenderingMode(vm.renderingMode)
                        .foregroundStyle(vm.selectedColor)
                        .padding()
                }
            }.padding(30)
                .frame(width: 250, height: 250)
                .background(.gray.opacity(0.2))
                .cornerRadius(18)


            Text(symbol)
                .font(.headline)
                .fontWeight(.medium)
                .onTapGesture {
                    UIPasteboard.general.string = symbol
                    showAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showAlert = false
                    }
                }

            List {
                Section {
                    ColorPicker("Pick a Color", selection: $vm.selectedColor)
                }

                Section("Resize Symbol: \(Int(vm.symbolSize))") {
                    Slider(value: $vm.symbolSize, in: 45...200, step: 1)
                }

                Section("Code Preview:") {
                    VStack(alignment: .center, spacing: 10) {
                        Button{
                            UIPasteboard.general.string = "Image(systemName: \"\(symbol)\")"
                            showAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showAlert = false
                            }
                        } label: {
                            Text("Image(systemName: \"\(symbol)\")")
                                .font(.system(.body, design: .monospaced)) // Monospaced font for code formatting
                                .padding(5)
                                .background(Color.gray.opacity(0.2)) // Light gray background for contrast
                                .cornerRadius(5)
                                .multilineTextAlignment(.center)
                        }.buttonStyle(.borderless)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle()) // Optional for better styling on iOS


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

            Spacer()
        }
        .navigationTitle("Symbol Preview")

        .overlay(
            // Show alert-like view
            VStack {
                Spacer()
                if showAlert {
                    Text("Copied!")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: showAlert)
                }
            }
        )
    }

}

#Preview {
    SymbolDetailView(symbol: "heart", vm: SymbolGridViewModel())
}
