from flask import Flask, request, redirect
import spotipy
from spotipy.oauth2 import SpotifyOAuth
import jsonify
from dotenv import load_dotenv
import os


CLIENT_ID = "4b75fc2e93ff43ac826df339a8d61e43"
CLIENT_SECRET = "b4e2df89183544a5b8c1880ee41acc99"
REDIRECT_URI = "http://localhost:5000/callback"

# Initialize the Flask app
app = Flask(__name__)

# Initialize the Spotify API client
sp = spotipy.Spotify(auth_manager=SpotifyOAuth(
    client_id=CLIENT_ID,
    client_secret=CLIENT_SECRET,
    redirect_uri=REDIRECT_URI,
    scope='user-library-read'  # Permission to access the user's library
))

# Get the current user's playlists
user_playlists = sp.current_user_playlists()


# Initialize variables to keep track of the longest playlist
longest_playlist_name = ""
longest_playlist_track_count = 0


# Find the longest playlist
for playlist in user_playlists['items']:
   playlist_name = playlist['name']
   playlist_id = playlist['id']
  
   # Get the number of tracks in the playlist
   playlist_tracks = sp.playlist_tracks(playlist_id)
   track_count = playlist_tracks['total']


   # Check if this playlist is longer than the current longest
   if track_count > longest_playlist_track_count:
       longest_playlist_name = playlist_name
       longest_playlist_track_count = track_count


# Print the longest playlist
if longest_playlist_name:
   print(f"The longest playlist is '{longest_playlist_name}' with {longest_playlist_track_count} tracks.")
else:
   print("No playlists found.")

@app.route('/callback', methods=['GET'])
def callback():
    # Get the access token after successful Spotify login
    sp.auth_manager.get_access_token(request.args['code'])

    # Redirect to the front-end URL (you should change this URL to match your Swift app's callback)
    return redirect('http://localhost:5000/callback')

@app.route('/longest-playlist', methods=['GET'])
def longest_playlist():
    return jsonify({"name": longest_playlist_name, "track_count": longest_playlist_track_count})

if __name__ == '__main__':
    app.run(debug=True)
