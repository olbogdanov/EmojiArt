//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by bogdanov on 25.04.21.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument

    @Binding var chosenPalette: String

    @State private var showPaletteEditor = false

    var body: some View {
        HStack {
            Stepper(
                onIncrement: {
                    chosenPalette = document.palette(after: chosenPalette)
                },
                onDecrement: {
                    chosenPalette = document.palette(before: chosenPalette)
                },
                label: {
                    EmptyView()
                })
            Text(document.paletteNames[chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPaletteEditor)
                        .environmentObject(document)
                        .frame(minWidth: 300, minHeight: 450)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument

    @Binding var chosenPalette: String

    @Binding var isShowing: Bool

    @State private var paletteName: String = ""

    @State private var emojisToAdd: String = ""

    private let columns = [
        GridItem(.adaptive(minimum: 40))
    ]

    private let fontSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor").font(.headline)
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }, label: { Text("Done") })
                }
            }.padding()
            Divider()
            Form {
                Section {
                    TextField("Palette name", text: $paletteName) { began in
                        if !began {
                            document.renamePalette(chosenPalette, to: paletteName)
                        }
                    }
                    TextField("Add Emoji", text: $emojisToAdd) { began in
                        if !began {
                            chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                            emojisToAdd = ""
                        }
                    }
                }
                Section(header: Text("Remove Emoji")) {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                                Text(emoji).font(Font.system(size: fontSize))
                                    .onTapGesture {
                                        chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
                                    }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            paletteName = document.paletteNames[chosenPalette] ?? ""
        }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
