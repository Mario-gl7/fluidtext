import SwiftUI

struct VocabularyListView: View {
    var words: [VocabEntry]
    var body: some View {
        List(words) { entry in
            VStack(alignment: .leading) {
                Text(entry.word).font(.headline)
                Text(entry.translation).foregroundColor(.secondary)
                Text("Gender: \(entry.gender)").font(.caption)
            }
        }
        .navigationTitle("Vocabulary")
    }
}
