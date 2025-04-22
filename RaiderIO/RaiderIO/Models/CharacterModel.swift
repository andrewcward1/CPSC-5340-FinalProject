/*
 Character model.
 Character parameters are fetched via API call.
 */

import Foundation


struct Character: Codable, Identifiable {
    let id = UUID()
    let name: String
    let race: String
    let `class`: String
    let faction: String
    let thumbnail_url: String
}

typealias CharacterResponse = [String: [Character]]
