<h2>Before You do any buidling just check Bin/ios/ if you have Bin/ios/MyLibrary.framework and Bin/ios/SwiftGodot.framework just copy them to dogodot skip build process</h2>

# Godot Apple Sign-In Library ✨

<div align="center">
    <h1>SwiftGodot Apple Sign-In Library</h1>
    <h3>A lightweight, easy-to-integrate library for implementing Apple Sign-In with Firebase in Godot 4.3+ on iOS</h3>
    
    🚀 **Swift** | 🎮 **Godot** | 🍏 **iOS**
</div>

---

## 🚀 Step-by-Step Integration Guide

### 1️⃣ Set Up Your Xcode Project
1. **Create a new Swift Package** in Xcode.
2. **Add dependencies** for Firebase and SwiftGodot.
3. **Enable Apple Sign-In** in your Xcode project:
   - Open your **project settings**.
   - Navigate to **Signing & Capabilities**.
   - Add **Sign In with Apple**.
4. **Add `GoogleService-Info.plist`** to your Xcode project (required for Firebase).

---

### 2️⃣ Write the Swift Code
Create a Swift class to handle Apple Sign-In and Firebase authentication. Use **SwiftGodot** to expose methods and signals to Godot.

#### Example Swift Code:
ALREADY DID IT FOR YOU

---

### 3️⃣ Build the Framework
Use the provided **`build.sh`** script to compile your Swift code into a `.framework` file.

#### Run the following commands in your terminal:
```sh
chmod +x build.sh
./build.sh ios release
```
📂 The compiled framework will be available in the `Bin/ios/` directory.

---

### 4️⃣ Set Up in Godot
1. **Create a new file** named `MyLibrary.gdextension` in your Godot project’s root directory (`res://`).
2. **Add the following content** to the file:
```ini
[configuration]
entry_symbol = "swift_entry_point"
compatibility_minimum = "4.3"

[libraries]
ios.release = "res://Bin/ios/MyLibrary.framework"

[dependencies]
ios.release = {"res://Bin/ios/SwiftGodot.framework" : ""}
```
3. **Copy the `.framework` files** from `Bin/ios/` to `res://Bin/ios/` in your Godot project.

---

### 5️⃣ Write the Godot Script
Use the following GDScript to integrate Apple Sign-In into your Godot project.

#### Example Godot Script:
```gdscript
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
```

---

### 🔄 Rebuild & Update the Plugin
- If you modify the Swift code, **rebuild** the framework using the `build.sh` script.
- Copy the **updated `.framework` files** to your Godot project.

---

## 🌟 Features
✅ **Apple Sign-In** with Firebase for **Godot 4.3+**.
✅ **Easy integration** with Godot via **GDExtension**.
✅ **Seamless authentication flow** with signals for success and error handling.
✅ **Optimized for iOS** with minimal setup.

---

## 🙌 Acknowledgements
- **SwiftGodot** for bridging **Swift and Godot**.
- **Firebase** for authentication services.
- **Apple** for **Sign In with Apple**.

---

## 🎮 Try My Games!
<div align="center">
    <h2>See this plugin in action and support my work! 🎉</h2>
    <table>
        <tr>
            <td align="center">
                <img src="https://play-lh.googleusercontent.com/l-usbpBq0OuurA1e9FJSlnnVVa1HQpcUCMv_RlM63zk7jGUvXRC10Z9hDuqA83DTU6A=w240-h480-rw" width="120" height="120"><br>
                <b>Ludo World War</b><br>
                <a href="https://apps.apple.com/np/app/ludo-app-gold/id6504749605">
                    <img src="https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg" width="120">
                </a>
            </td>
            <td align="center">
                <img src="https://play-lh.googleusercontent.com/l-usbpBq0OuurA1e9FJSlnnVVa1HQpcUCMv_RlM63zk7jGUvXRC10Z9hDuqA83DTU6A=w240-h480-rw" width="120" height="120"><br>
                <b>Ludo World War</b><br>
                <a href="https://play.google.com/store/apps/details?id=com.ludosimplegame.ludo_simple">
                    <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" width="140">
                </a>
            </td>
        </tr>
    </table>
</div>

⭐ **Your ratings & reviews help tremendously!** ⭐



