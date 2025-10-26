import Foundation

struct VocabEntry: Identifiable, Codable {
    let id = UUID()
    let word: String
    let translation: String
    let gender: String
}

class VocabCache {
    static let shared = VocabCache()
    private let fileURL: URL
    private var cache: [VocabEntry] = []
    
    private init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = dir.appendingPathComponent("vocab.json")
        cache = loadWords()
    }

    func saveWord(_ word: String, translation: String, gender: String) {
        if !cache.contains(where: { $0.word.lowercased() == word.lowercased() }) {
            cache.append(VocabEntry(word: word, translation: translation, gender: gender))
            save()
        }
    }

    func lookup(_ word: String) -> VocabEntry? {
        return cache.first(where: { $0.word.lowercased() == word.lowercased() })
    }

    func save() {
        if let data = try? JSONEncoder().encode(cache) {
            try? data.write(to: fileURL)
        }
    }

    func loadWords() -> [VocabEntry] {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([VocabEntry].self, from: data) else { return [] }
        return decoded
    }
}
