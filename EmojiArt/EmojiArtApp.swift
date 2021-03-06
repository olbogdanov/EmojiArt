//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by bogdanov on 22.04.21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let store = EmojiArtDocumentStore(directory: url)
        WindowGroup {
            EmojiArtDocumentChooser().environmentObject(store)
        }
    }
}
