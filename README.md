# Flutter Google Maps

This Flutter application demonstrates how to integrate Google Maps, obtain the user's current location, and draw a route between two selected points on the map using the Google Directions API.

## Features

- Display Google Map
- Show user's current location
- Select two points on the map and draw a route between them
- Fetch route data from Google Directions API and draw the route on the map

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine
- A Google Cloud project with the Maps SDK for Android, Maps SDK for iOS, and Directions API enabled
- A Google API key with the necessary permissions

### Installation

1. **Clone the repository**:

    ```sh
    git clone https://github.com/your-username/flutter-google-maps-route-drawer.git
    cd flutter-google-maps-route-drawer
    ```

2. **Install dependencies**:

    ```sh
    flutter pub get
    ```

3. **Configure your Google API key**:

    Replace `YOUR_GOOGLE_API_KEY` in the `_getDirections` method with your actual Google API key.

4. **Configure Android project**:

    Open `android/app/src/main/AndroidManifest.xml` and add your API key inside the `<application>` tag.

5. **Configure iOS project**:

    Open `ios/Runner/AppDelegate.swift` and add your API key.

### Running the App

Run the app on an emulator or a physical device:

```sh
flutter run
