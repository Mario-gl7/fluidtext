import SwiftUI
import PDFKit
import NaturalLanguage
import AVFoundation

// Note: EPUB support requires FolioReaderKit added as a package in Xcode.
// See README for instructions.

struct ContentView: View {
    @State private var showImporter = false
    @State private var documentURL: URL?
    @State private var pdfDocument: PDFDocument?
    @State private var isEPUB = false
    @State private var selectedText = ""
    @State private var translation = ""
    @State private var gender = ""
    @State private var highlightedWords: Set<String> = []
    @State private var vocabList: [VocabEntry] = []
    @State private var showVocabList = false
    @State private var immersiveMode = false
    @State private var speechEnabled = false

    var body: some View {
        NavigationView {
            ZStack {
                if let pdfDoc = pdfDocument, !isEPUB {
                    PDFViewContainer(pdfDocument: pdfDoc, onSelect: handleSelection)
                } else if isEPUB, let url = documentURL {
                    // EPUB container view is added if FolioReaderKit is added via SPM
                    EPUBViewPlaceholder(epubURL: url, onSelect: handleSelection)
                } else {
                    Text("📚 Importa un PDF o EPUB en alemán para empezar")
                        .font(.title2).padding()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showImporter = true }) {
                        Label("Importar", systemImage: "square.and.arrow.down")
                    }
                    Button(action: { immersiveMode.toggle() }) {
                        Label("Inmersivo", systemImage: immersiveMode ? "book.closed.fill" : "book")
                    }
                    Button(action: { showVocabList = true }) {
                        Label("Vocabulario", systemImage: "list.bullet")
                    }
                }
            }
            .fileImporter(isPresented: $showImporter,
                          allowedContentTypes: [.pdf, .epub]) { result in
                guard let url = try? result.get() else { return }
                documentURL = url
                isEPUB = url.pathExtension.lowercased() == "epub"
                pdfDocument = isEPUB ? nil : PDFDocument(url: url)
            }
            .sheet(isPresented: $showVocabList) {
                VocabularyListView(words: vocabList)
            }
            .padding()
        }
    }

    func handleSelection(_ text: String) {
        selectedText = text
        Task { await translateAndSpeak(text) }
    }

    func translateAndSpeak(_ text: String) async {
        let (translated, gen) = await Translator.shared.translate(text)
        DispatchQueue.main.async {
            translation = translated
            gender = gen
            highlightedWords.insert(text.lowercased())
            VocabCache.shared.saveWord(text, translation: translated, gender: gen)
            vocabList = VocabCache.shared.loadWords()
            if speechEnabled {
                SpeechHelper.shared.speak(text, lang: "de-DE")
                SpeechHelper.shared.speak(translated, lang: "es-ES")
            }
        }
    }
}
