//
//  CharacterDetailView.swift
//  RaiderIO
//
//  Created by Andrew Ward on 4/27/25.
//

import SwiftUI

/*
 Detail view of the character(s) fetched from the RaiderIO API call from the main screen
 */



struct CharacterDetailView: View {
    var characterIn: Character
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AttributeView(attribute: "Name: ", value: characterIn.name)
                AttributeView(attribute: "Race: ", value: characterIn.race)
                AttributeView(attribute: "Class: ", value: characterIn.class)
                AttributeView(attribute: "Faction: ", value: characterIn.faction)
                
            }
        }
    }
}
