//
//  SessionsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 01.12.2023.
//

import SwiftUI

struct SessionsView: View {
 @StateObject private var manager = Manager.shared
 @State private var sessions: [Session] = []
 @State private var isLoading: Bool = true

 var body: some View {
     ZStack {
         Color.black.edgesIgnoringSafeArea(.all)

         VStack {
             VStack {
               Text("Your sessions")
                  .font(.largeTitle)
                  .foregroundColor(.white)
                  .padding(.top, 20)
             }

             Spacer()

             if isLoading {
               ProgressView()
                  .progressViewStyle(CircularProgressViewStyle(tint: .white))
                  

               Spacer()
             } else if sessions.isEmpty {
               // Display "No sessions available." message
             } else {
               List {
                  ForEach(sessions.indices, id: \.self) { index in
                      VStack(alignment: .leading) {
                          TextField("Session Name", text: $sessions[index].name)
                              .font(.headline)
                          Text("Created at: \(sessions[index].recordedAt)")
                              .font(.subheadline)
                          Text("Duration: \(sessions[index].duration) seconds")
                              .font(.subheadline)
                      }
                      .onChange(of: sessions[index].name) { newValue in
                                             let sessionCopy = sessions[index]
                                             sessionCopy.name = newValue
                                             Task {
                                                 await manager.updateSession(sessionCopy)
                                             }
                                         }
                  }
                  .onDelete(perform: deleteSessions)
                  .onMove(perform: moveSessions)
               }
               .background(.black)
               .frame(maxWidth: .infinity, maxHeight: .infinity)
             }
         }
         .onAppear {
             Task {
                 sessions = await manager.getSessions()
                 isLoading = false
             }
         }
     }
 }

 private func deleteSessions(offsets: IndexSet) {
     offsets.forEach { index in
         let session = sessions[index]
         Task {
             await manager.deleteSession(session)
         }
     }
     sessions.remove(atOffsets: offsets)
 }

 private func moveSessions(source: IndexSet, destination: Int) {
     sessions.move(fromOffsets: source, toOffset: destination)
 }
}
