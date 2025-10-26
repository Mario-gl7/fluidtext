import SwiftUI
import UIKit

// Placeholder view shown if FolioReaderKit isn't installed.
// If you add FolioReaderKit via Swift Package Manager, replace this file
// with a proper FolioReader integration view controller wrapper.
struct EPUBViewPlaceholder: View {
    var epubURL: URL
    var onSelect: (String) -> Void
    var body: some View {
        VStack(spacing: 12) {
            Text("EPUB: FolioReaderKit no instalado").foregroundColor(.secondary)
            Text("Para soporte EPUB, añade FolioReaderKit como dependencia en Xcode.").font(.caption)
            Text(epubURL.lastPathComponent).font(.footnote)
        }
        .padding()
    }
}
