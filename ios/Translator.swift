import Foundation
import NaturalLanguage

actor Translator {
    static let shared = Translator()
    private init() {}
    
    // PONS API
    private let ponsEndpoint = "https://api.pons.com/v1/dictionary"
    private let ponsAuthKey = "<YOUR_PONS_API_KEY>" // <-- Reemplaza con tu clave en Xcode's config or env

    func translate(_ text: String) async -> (String, String) {
        if let cached = VocabCache.shared.lookup(text) {
            return (cached.translation, cached.gender)
        }
        let translated = await translateViaPons(text)
        let gender = detectGender(for: text)
        return (translated, gender)
    }

    private func translateViaPons(_ text: String) async -> String {
        guard let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(ponsEndpoint)?q=\(encoded)&l=deen") else { return "[error]" }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(ponsAuthKey, forHTTPHeaderField: "X-Secret")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
               let first = json.first,
               let hits = first["hits"] as? [[String: Any]],
               let firstHit = hits.first,
               let roms = firstHit["roms"] as? [[String: Any]],
               let headword = roms.first?["headword"] as? String {
                return headword
            }
        } catch {
            print("PONS translation error:", error.localizedDescription)
        }
        return "[untranslated]"
    }

    private func detectGender(for word: String) -> String {
        if word.hasPrefix("der ") { return "masculine" }
        if word.hasPrefix("die ") { return "feminine" }
        if word.hasPrefix("das ") { return "neuter" }
        return "unknown"
    }
}
