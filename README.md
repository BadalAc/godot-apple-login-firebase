SwiftGodot Apple Sign-In Library ✨
<div align="center">
Swift
Godot
iOS

A lightweight, easy-to-integrate library for implementing Apple Sign-In with Firebase in Godot 4.3+ on iOS

</div>
🚀 Step-by-Step Process
1. Set Up Your Xcode Project
Create a new Swift Package in Xcode.

Add dependencies for Firebase and SwiftGodot.

Enable Apple Sign-In in your Xcode project:

Go to your project settings.

Under Signing & Capabilities, add Sign In with Apple.

Add the GoogleService-Info.plist file to your Xcode project (required for Firebase).

2. Write the Swift Code
Create a Swift class to handle Apple Sign-In and Firebase authentication.

Use SwiftGodot to expose methods and signals to Godot.

Example Swift Code:
swift
Copy
import Foundation
import SwiftGodot
import FirebaseAuth
import AuthenticationServices

@Godot
class MyLibrary: Object {
    private var currentNonce: String?

    @Callable
    func signIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    @Callable
    func signOut() {
        do {
            try Auth.auth().signOut()
            emitSignal("Signout", "User signed out")
        } catch {
            emitSignal("Output", "Error: \(error.localizedDescription)")
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
        // Generate a random nonce string
    }

    private func sha256(_ input: String) -> String {
        // Compute SHA256 hash
    }
}

extension MyLibrary: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // Handle Apple Sign-In success
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle Apple Sign-In error
    }
}
3. Build the Framework
Use the provided build.sh script to compile your Swift code into a .framework file.

Run the following commands in your terminal:

sh
Copy
chmod +x build.sh
./build.sh ios release
The compiled framework will be available in the Bin/ios/ directory.

4. Set Up in Godot
Create a new file named MyLibrary.gdextension in your Godot project's root directory (res://).

Add the following content to the file:

ini
Copy
[configuration]
entry_symbol = "swift_entry_point"
compatibility_minimum = "4.3"

[libraries]
ios.release = "res://Bin/ios/MyLibrary.framework"

[dependencies]
ios.release = {"res://Bin/ios/SwiftGodot.framework" : ""}
Copy the .framework files from Bin/ios/ to your Godot project's res://Bin/ios/ directory.

5. Write the Godot Script
Use the following GDScript to integrate Apple Sign-In into your Godot project.

Example Godot Script:
gdscript
Copy
extends Control

@onready var apple_button = $Panel/AppleLoginButton
@onready var error_label = $Panel/MarginContainer/ErrorLabel
@onready var status_label = $Panel/StatusLabel
@onready var loading_indicator = $Panel/LoadingIndicator

var my_library = null

func _ready() -> void:
    error_label.hide()
    if loading_indicator:
        loading_indicator.hide()

    # Initialize the plugin
    if ClassDB.class_exists("MyLibrary"):
        my_library = ClassDB.instantiate("MyLibrary")
        my_library.connect("Output", _on_apple_output_signal)
        my_library.connect("Signout", _on_apple_signout_signal)
    else:
        error_label.show()
        error_label.text = "Apple Sign-In unavailable"

func _on_apple_button_pressed() -> void:
    if loading_indicator:
        loading_indicator.show()
    error_label.hide()

    if my_library:
        my_library.signIn()
    else:
        show_error("Apple plugin not initialized")

func _on_apple_output_signal(output: String) -> void:
    if loading_indicator:
        loading_indicator.hide()

    if output.begins_with("Error:"):
        show_error(output)
    else:
        show_status(output)

func _on_apple_signout_signal(signout: String) -> void:
    show_status(signout)

func show_error(message: String) -> void:
    error_label.show()
    error_label.text = message

func show_status(message: String) -> void:
    status_label.text = message
    status_label.show()
6. Rebuild & Update the Plugin
If you modify the Swift code, rebuild the framework using the build.sh script.

Copy the updated .framework files to your Godot project.

🌟 Features
Apple Sign-In with Firebase for Godot 4.3+.

Easy integration with Godot via GDExtension.

Seamless authentication flow with signals for success and error handling.

Optimized for iOS with minimal setup.

🙌 Acknowledgements
SwiftGodot for bridging Swift and Godot.

Firebase for authentication services.

Apple for Sign In with Apple.

🎮 Try My Games!
<div align="center"> <h1>See this plugin in action and support my work!</h1> <table> <tr> <td align="center"> <img src="https://play-lh.googleusercontent.com/l-usbpBq0OuurA1e9FJSlnnVVa1HQpcUCMv_RlM63zk7jGUvXRC10Z9hDuqA83DTU6A=w240-h480-rw" width="120" height="120"><br> <b>Ludo World War</b><br> <a href="https://apps.apple.com/np/app/ludo-app-gold/id6504749605"> <img src="https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg" width="120"> </a> </td> <td align="center"> <img src="https://play-lh.googleusercontent.com/l-usbpBq0OuurA1e9FJSlnnVVa1HQpcUCMv_RlM63zk7jGUvXRC10Z9hDuqA83DTU6A=w240-h480-rw" width="120" height="120"><br> <b>Ludo World War</b><br> <a href="https://play.google.com/store/apps/details?id=com.ludosimplegame.ludo_simple"> <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" width="140"> </a> </td> </tr> </table>
⭐ Your ratings & reviews help tremendously! ⭐

Help us grow and bring you more amazing features!

</div>
<p align="center"> Enjoy coding & gaming! 🎮🚀 </p>
This guide and documentation are now ready for public demonstration and provide a clear, step-by-step process for integrating Apple Sign-In with Firebase into Godot using Swift.
