from flask import Flask, request, redirect
import spotipy
from spotipy.oauth2 import SpotifyOAuth

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

@app.route('/callback', methods=['GET'])
def callback():
    # Get the access token after successful Spotify login
    sp.auth_manager.get_access_token(request.args['code'])

    # Redirect to the front-end URL (you should change this URL to match your Swift app's callback)
    return redirect('YOUR_SWIFT_UI_REDIRECT_URL')

if __name__ == '__main__':
    app.run(debug=True)
