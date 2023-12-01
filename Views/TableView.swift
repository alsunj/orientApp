//
//  TableView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 23.11.2023.
//

import SwiftUI

struct Table: View {
    let variable: String
    @Binding var value: Double
    
    var body: some View {
        HStack (spacing: 5){
            VStack() {
                Text(" " + variable + "  ")
                
            }
            VStack() {
                Text(" \(value) ")
            }
        }
        
        .padding(.bottom)
        .font(.system(size: 9))
        .cornerRadius(7)
        .frame(maxWidth: UIScreen.main.bounds.size.width / 3.5)
    }
}




