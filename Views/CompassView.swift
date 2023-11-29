//
//  CompassView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 21.11.2023.
//

import SwiftUI

struct CompassView: View {
    @ObservedObject var compassManager = CompassManager()

    var body: some View {
        VStack {
            Image(systemName: "arrow.up")
                .fixedSize()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(compassManager.heading))
        }
        .onAppear {
            compassManager.checkCompassPermission()
        }
    }
}
#Preview {
    CompassView()
}
