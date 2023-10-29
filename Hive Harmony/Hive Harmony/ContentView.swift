//
//  ContentView.swift
//  Hive Harmony
//
//  Created by Alexandra Marum on 10/28/23.
//

import SwiftUI
import SafariServices

struct HomeView: View {
    @State private var isAuthenticated = false
    
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
                if isAuthenticated {
                    // Once authenticated, show the main content of your app
                    ContentView()
                } else {
                    // Show the login button
                    SpotifyLoginView(isAuthenticated: $isAuthenticated)
                }
            }
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
        isAuthenticated = true
        return components.url!
    }
}

struct ContentView: View {
    @State private var longestPlaylist: LongestPlaylist?

    var body: some View {
        VStack {
            if let playlist = longestPlaylist {
                // Display the longest playlist data
                Text("Longest Playlist: \(playlist.name)")
                Text("Track Count: \(playlist.trackCount)")
            } else {
                // Fetch the data when it's not available
                Button("Fetch Longest Playlist") {
                    fetchLongestPlaylist()
                }
            }
        }
    }

    func fetchLongestPlaylist() {
        if let url = URL(string: "http://localhost:5000/longest-playlist") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let playlist = try JSONDecoder().decode(LongestPlaylist.self, from: data)
                        DispatchQueue.main.async {
                            self.longestPlaylist = playlist
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}

struct LongestPlaylist: Codable {
    let name: String
    let trackCount: Int
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

struct User: Codable {
    let name: String
    let userID: String
}

struct Song {
    let name: String
    let artist: String
    let image: String
}

struct Playlist {
    let songs: [String]
}
