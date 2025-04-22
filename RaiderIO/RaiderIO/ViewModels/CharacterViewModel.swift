/*
 CharacterViewModel.
 Used to fetch character information from RaiderIO API.
 API documentation available at: https://raider.io/api
 https://raider.io/api/v1/characters/profile?region=us&realm=malganis&name=\(characterIn)
 */

import SwiftUI

class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    
    func fetchCharacterData(characterIn: String) {
        guard let url = URL(string: "https://raider.io/api/v1/characters/profile?region=us&realm=malganis&name=\(characterIn)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    DispatchQueue.main.async {
                        if let characterData = decodedResponse[characterIn] {
                            self.characters = characterData
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}
