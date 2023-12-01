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
    @State private var filteredSessions: [Session] = []
    @State private var isLoading: Bool = true
    @State private var searchText: String = ""
    @State var mailResult: Bool? = nil
    @State var showMailResult = false
    
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
                    Text("empty")
                } else {
                    //                    HStack {
                    //                        TextField("Search Session Name", text: $searchText)
                    //                            .padding(.horizontal)
                    //                        Button("Search") {
                    //                            performSearch()
                    //                        }
                }
                List {
                    ForEach(sessions) { session in
                        SessionView( // Assuming SessionView is the correct view for displaying individual sessions
                            session: session,
                            mailResult: $mailResult,
                            showMailResult: $showMailResult
                        )
                    }
                    .onDelete(perform: deleteSessions)
                    .onMove(perform: moveSessions)
                }
                .alert(isPresented: $showMailResult) {
                    Alert(
                        title: Text(mailResult! ? "Email sent!" : "Failed to send email, try again!"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                //                    }
                
            }
            
            .background(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        .onAppear {
            Task {
                sessions = await manager.getSessions()
                isLoading = false
            }
        }
    }
    
    private func performSearch() {
        filteredSessions = sessions.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
