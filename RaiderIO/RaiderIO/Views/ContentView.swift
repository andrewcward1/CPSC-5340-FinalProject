
/*
 Once authenticated, the screen below is shown.
 This is our main entry point to the actual application.
 */


import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var viewModel = CharacterViewModel()
    @State private var region: String = ""
    @State private var realm: String = ""
    @State private var characterName: String = ""
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Welcome to Raider IO!")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
                        
                        Button(action: {
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                withAnimation {
                                    userID = ""
                                }
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }) {
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                        
                        Text("Search By Region, Realm, and Character Name")
                            .font(.headline)
                            .padding(.top)
                        
                        Group {
                            TextField("Example: us", text: $region)
                                .padding()
                                .frame(height: 50)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .disableAutocorrection(true)
                            
                            TextField("Example: Malganis", text: $realm)
                                .padding()
                                .frame(height: 50)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .disableAutocorrection(true)
                            
                            TextField("Example: Edgeward", text: $characterName)
                                .padding()
                                .frame(height: 50)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .disableAutocorrection(true)
                        }
                        
                        Button(action: {
                            viewModel.fetchCharacterData(regionIn: region, realmIn: realm, characterIn: characterName)
                        }) {
                            Text("Search")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Raider IO")
                .navigationBarTitleDisplayMode(.inline)
            }
            
            NavigationView {
                List {
                    ForEach(viewModel.characters) { character in
                        VStack(alignment: .leading) {
                            NavigationLink(destination: CharacterDetailView(characterIn: character)) {
                                HStack {
                                    
                                    AsyncImage(url: URL(string: character.thumbnail_url)) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(5)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                    
                                    
                                    Text(character.name)
                                        .font(.headline)
                                }
                            }
                        }
                        .padding()
                    }
                    .onDelete(perform: viewModel.deleteCharacter)
                }

                .navigationTitle("Character Info")
                .onAppear {
                    viewModel.loadCharactersFromFirestore()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

