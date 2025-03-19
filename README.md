# SwiftGodot Apple Sign-In Library ✨

<div align="center">
  
  ![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
  ![Godot](https://img.shields.io/badge/Godot-478CBF?style=for-the-badge&logo=GodotEngine&logoColor=white)
  ![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
  
  **A lightweight, easy-to-integrate library for implementing Apple Sign-In with Firebase in Godot 4.3+ on iOS**
</div>

## 📂 Project Structure

```
Bin/
  ios/
    MyLibrary.framework/
      Info.plist
      MyLibrary
    SwiftGodot.framework/
      Info.plist
      SwiftGodot
```

## 🛠️ Building the Framework (Already built in `Bin/ios/`, if missing, follow below steps)

To build the framework, run the following commands:

```sh
chmod +x build.sh
./build.sh ios release
```

After running the script, you will find the built files inside the `Bin/` directory.

## 🔗 Setting Up in Godot

1. **Create a new file named `MyLibrary.gdextension` in the root directory (`res://`).**
2. Paste the following content into the file:

```ini
[configuration]
entry_symbol = "swift_entry_point"
compatibility_minimum = "4.3"

[libraries]
ios.release = "res://Bin/ios/MyLibrary.framework"

[dependencies]
ios.release = {"res://Bin/ios/SwiftGodot.framework" : ""}
```

### 📌 Important:
- **This file is required to link Godot to iOS.**
- Copy the framework files into `res://Bin/ios/` before running Godot.

## ⚠️ MUST INCLUDE GOOGLE SERVICE INFO PLIST

**Make sure to include `GoogleService-Info.plist` in your Xcode project.**

This is required for Firebase authentication integration with Apple Sign-In.

## 🔐 Xcode Setup

- Ensure **Apple Login** is added in Xcode.
- You **must have an Apple Developer account** to use Apple Sign-In with Firebase.

## 🔋 Godot Script Example

Here's a sample **Godot script (`GDScript`)** demonstrating how to use Apple Sign-In:

extends Control

@onready var apple_button = $Panel/AppleLoginButton
@onready var back_button = $Panel/MarginContainer2/HBoxContainer/GoBackButton
@onready var error_label = $Panel/MarginContainer/ErrorLabel
@onready var status_label = $Panel/StatusLabel
@onready var loading_indicator = $Panel/LoadingIndicator

@onready var http_request = $HTTPRequest

# File path for saving demo user data (temporary location)
const DEMO_USER_DATA_FILE := "user://demo_user_data.json"

func _ready() -> void:
	# Initially hide status elements
	error_label.hide()
	if loading_indicator:
		loading_indicator.hide()
	
	# Connect signals
	http_request.request_completed.connect(_on_http_request_completed)
	apple_button.pressed.connect(_on_apple_button_pressed)
	back_button.pressed.connect(_on_go_back_button_pressed)

func _on_apple_button_pressed() -> void:
	# Simulate a button click sound (for demo purposes)
	print("Apple button pressed")
	
	# Show loading indicator
	if loading_indicator:
		loading_indicator.show()
	
	# Hide error label
	error_label.hide()
	
	# Simulate Apple Sign-In process
	simulate_apple_sign_in()

func simulate_apple_sign_in() -> void:
	# Simulate a successful Apple Sign-In with dummy data
	var dummy_user_data = {
		"user_id": "demo_user_123",
		"email": "demo_user@example.com",
		"name": "Demo User",
		"id_token": "dummy_id_token_123"
	}
	
	# Process the dummy user data
	_process_demo_user_data(dummy_user_data)

func _process_demo_user_data(user_data: Dictionary) -> void:
	# Simulate processing user data (e.g., sending to a server)
	print("Processing demo user data:", user_data)
	
	# Save the dummy user data to a file
	save_demo_user_data(user_data)
	
	# Show a success message
	show_status("Demo login successful!")

func save_demo_user_data(user_data: Dictionary) -> void:
	# Save the user data to a temporary file for demonstration purposes
	var file = FileAccess.open(DEMO_USER_DATA_FILE, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(user_data, "  ")
		file.store_string(json_string)
		print("Demo user data saved to:", DEMO_USER_DATA_FILE)
	else:
		push_error("Failed to save demo user data")

func load_demo_user_data() -> Dictionary:
	# Load the demo user data from the temporary file
	if not FileAccess.file_exists(DEMO_USER_DATA_FILE):
		print("No demo user data found")
		return {}
	
	var file = FileAccess.open(DEMO_USER_DATA_FILE, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			var data = json.get_data()
			print("Demo user data loaded:", data)
			return data
		else:
			push_error("Failed to parse demo user data")
	else:
		push_error("Failed to open demo user data file")
	
	return {}

func _on_http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	# Handle HTTP request completion (for demo purposes)
	if loading_indicator:
		loading_indicator.hide()
	
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		print("HTTP request successful")
		show_status("Server verification complete!")
	else:
		show_error("HTTP request failed")

func show_error(message: String) -> void:
	# Show an error message
	if loading_indicator:
		loading_indicator.hide()
	error_label.show()
	error_label.text = message
	print("Error:", message)

func show_status(message: String) -> void:
	# Show a status message
	if status_label:
		status_label.text = message
		status_label.show()
	print("Status:", message)

func _on_go_back_button_pressed() -> void:
	# Simulate a button click sound (for demo purposes)
	print("Go back button pressed")
	
	# Hide the current panel (for demo purposes)
	$Panel.hide()

## 🔄 Rebuilding & Updating the Plugin

If you modify the Swift code, follow these steps to rebuild and update:

```sh
chmod +x build.sh
./build.sh ios release
```

Then, copy the updated files from `Bin/` to your Godot project and repeat the setup process.

## 🌟 Features

- Apple Sign-In with Firebase for Godot 4.3+
- Easy integration
- Seamless authentication flow
- Simple signals for handling authentication results
- Optimized for iOS

## 🙌 Acknowledgements



## 🎮 Try My Games!

<div align="center">
  <h1>See this plugin in action and support my work!</h1>
  
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
  
  ⭐ **Your ratings & reviews help tremendously!** ⭐
  
  Help us grow and bring you more amazing features!
</div>

---

<p align="center">
  Enjoy coding & gaming! 🎮🚀
</p>

