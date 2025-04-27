//
//  AttributeView.swift
//  RaiderIO
//
//  Created by Andrew Ward on 4/27/25.
//  Very simple view for character attribute details
//

import SwiftUI

struct AttributeView: View {
    
    var attribute : String
    var value : String
    
    var body: some View {
        HStack {
            Text(attribute)
            Text(value)
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.blue, lineWidth: 2)
        }
        
    }
}
