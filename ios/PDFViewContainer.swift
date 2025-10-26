import SwiftUI
import PDFKit

struct PDFViewContainer: UIViewRepresentable {
    let pdfDocument: PDFDocument
    var onSelect: (String) -> Void

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.document = pdfDocument
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        pdfView.addGestureRecognizer(tap)
        context.coordinator.pdfView = pdfView
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject {
        var parent: PDFViewContainer
        weak var pdfView: PDFView?
        init(_ parent: PDFViewContainer) { self.parent = parent }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let pdfView = pdfView else { return }
            let loc = sender.location(in: pdfView)
            guard let page = pdfView.page(for: loc, nearest: true) else { return }
            let point = pdfView.convert(loc, to: page)
            if let sel = page.selectionForWord(at: point),
               let word = sel.string?.trimmingCharacters(in: .whitespacesAndNewlines) {
                parent.onSelect(word)
            }
        }
    }
}
