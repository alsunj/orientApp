//
//  PictureTableView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import SwiftUI

struct PictureTableView: View {
    let picture: String
    @Binding var value : Double
    
    var body: some View {
        HStack(spacing: 5) {
            VStack {
                Image(systemName: picture)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
            }
            VStack{
                Text(" | ")
            }
            VStack {
                Text(" \(value) ")
            }
        }
        .padding(.bottom)
        .font(.system(size: 9))
        .cornerRadius(7)
        .frame(maxWidth: UIScreen.main.bounds.size.width / 3.5)
    }
}
