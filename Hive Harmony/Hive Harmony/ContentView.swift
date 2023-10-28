//
//  ContentView.swift
//  Hive Harmony
//
//  Created by Alexandra Marum on 10/28/23.
//

import SwiftUI
import SafariServices

struct HomeView: View {
    var body: some View {
        ZStack {
            Color("HiveYellow")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                Button{
                    
                } label: {
                
                }
                ContentView()
            }
        }
    }
}

struct ContentView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        if isAuthenticated {
            // Once authenticated, show the main content of your app
            Text("Welcome to your Spotify-integrated app!")
        } else {
            // Show the login button
            SpotifyLoginView(isAuthenticated: $isAuthenticated)
        }
    }
}

struct SpotifyLoginView: View {
    @Binding var isAuthenticated: Bool
    
    let clientId = "4b75fc2e93ff43ac826df339a8d61e43"
    let redirectUri = "http://localhost:5000/callback"
    
    @State private var isPresented = false
    
    var body: some View {
        Button("Log in with Spotify") {
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented) {
            SafariView(url: spotifyAuthURL)
        }
    }
    
    var spotifyAuthURL: URL {
        var components = URLComponents(string: "https://accounts.spotify.com/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "scope", value: "user-library-read playlist-read-private")
        ]
        return components.url!
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Update the view controller if needed
    }
}

    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
