/*
 Character model.
 Character parameters are fetched via API call to RaiderIO API.
 */

import Foundation
import FirebaseFirestore

struct Character: Identifiable, Codable {
    let id = UUID()
    let name: String
    let race: String
    let `class`: String
    let faction: String
    let thumbnail_url: String
}



