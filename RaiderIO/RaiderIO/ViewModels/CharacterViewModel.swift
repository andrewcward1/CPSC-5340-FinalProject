/*
 CharacterViewModel.
 Used to fetch character information from RaiderIO API.
 Characters are also added to Firestore DB on a per account basis.
 */

import SwiftUI
import FirebaseFirestore


class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    private var db = Firestore.firestore()
    @AppStorage("uid") var userID: String = ""

    // Add character to FireStore DB
    func saveCharacterToFirestore(_ character: Character) {
        guard !userID.isEmpty else { return }
        
        do {
            let _ = try db.collection("users").document(userID).collection("characters").addDocument(from: character)
        } catch {
            print("Error saving character to Firestore: \(error)")
        }
    }
    
    // Retrieve characters from FireStore DB
    func loadCharactersFromFirestore() {
        guard !userID.isEmpty else { return }

        db.collection("users").document(userID).collection("characters").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching characters: \(error)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            
            self.characters = documents.compactMap { document in
                try? document.data(as: Character.self)
            }
        }
    }


    func fetchCharacterData(regionIn: String, realmIn: String, characterIn: String) {
        guard let url = URL(string: "https://raider.io/api/v1/characters/profile?region=\(regionIn)&realm=\(realmIn)&name=\(characterIn)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedCharacter = try JSONDecoder().decode(Character.self, from: data)
                    DispatchQueue.main.async {
                        self.characters.append(decodedCharacter)
                        self.saveCharacterToFirestore(decodedCharacter)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func deleteCharacter(at offsets: IndexSet) {
           characters.remove(atOffsets: offsets)
       }
}

