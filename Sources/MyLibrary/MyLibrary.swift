import Foundation
import SwiftGodot
import AuthenticationServices
import CryptoKit
import FirebaseAuth // For authentication
import FirebaseCore // Add this for FirebaseApp

#if os(iOS)
import UIKit

class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var onSuccess: ((String, String?, String?, String) -> Void)? // Added idTokenString
    var onError: ((String) -> Void)?
    private var currentNonce: String?
    

    @available(iOS 17.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No valid window found")
        }
        return window
    }
    
  

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let credentials as ASAuthorizationAppleIDCredential:
        guard let appleIDToken = credentials.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8),
              let nonce = currentNonce else {
            onError?("Failed to retrieve Apple ID token or nonce")
            return
        }
        
        let id = credentials.user
        let email = credentials.email
        let name = "\(credentials.fullName?.givenName ?? "") \(credentials.fullName?.familyName ?? "")"
            .trimmingCharacters(in: .whitespaces)
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { result, error in
    if let error = error {
        self.onError?(error.localizedDescription)
        return
    }
    
    // Get a fresh ID token from Firebase after sign-in
    result?.user.getIDToken { idToken, error in
        if let error = error {
            self.onError?(error.localizedDescription)
            return
        }
        
        guard let idToken = idToken else {
            self.onError?("Could not retrieve ID token")
            return
        }
        
        UserDefaults.standard.set(id, forKey: "id")
        self.onSuccess?(id, email, name, idToken) // Pass Firebase ID token here
    }
}
    default:
        onError?("Received unknown credential type")
    }
}
    
    func generateNonce(length: Int = 32) -> String {
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        return String(randomBytes.map { charset[Int($0) % charset.count] }.prefix(length))
    }
    
    func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func prepareRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = generateNonce()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
}
#endif

#initSwiftExtension(
    cdecl: "swift_entry_point",
    types: [MyLibrary.self]
)


@Godot
class MyLibrary: RefCounted {
    #if os(iOS)
    private var signInDelegate: AppleSignInDelegate?
    private var isFirebaseConfigured = false // Track initialization state
    #endif
    
    #signal("Output", arguments: ["output": String.self])
    let signal = SignalWith1Argument<String>("Output")
    
    #signal("Signout", arguments: ["signout": String.self])
    let signalTwo = SignalWith1Argument<String>("Signout")
    
    let center = NotificationCenter.default
    let name = ASAuthorizationAppleIDProvider.credentialRevokedNotification
    
    // Change override init() to required init()
    required init() {
        super.init()
        #if os(iOS)
        // Automatically configure Firebase on initialization (optional)
        FirebaseApp.configure()
        isFirebaseConfigured = true
        emit(signal: signal, "Firebase auto-configured")
        #endif
    }
    
    // Add the required initializer
    required init(nativeHandle: UnsafeRawPointer) {
        super.init(nativeHandle: nativeHandle)
    }

    @Callable
    func setupFirebase() {
        #if os(iOS)
        if !isFirebaseConfigured {
            FirebaseApp.configure()
            isFirebaseConfigured = true
            emit(signal: signal, "Firebase configured")
        } else {
            emit(signal: signal, "Firebase already configured")
        }
        #else
        emit(signal: signal, "Firebase not supported on this platform")
        #endif
    }
    
@Callable
func signIn() {
    #if os(iOS)
    guard isFirebaseConfigured else {
        emit(signal: signal, "Error: Firebase not configured")
        return
    }
    signInDelegate = AppleSignInDelegate()
    
    signInDelegate?.onSuccess = { [weak self] (id: String, email: String?, name: String?, idTokenString: String) in
        guard let self = self else { return }
        let output = "\(id) \(email ?? "") \(name ?? "") \(idTokenString)"
        emit(signal: self.signal, output)
    }
    
    signInDelegate?.onError = { [weak self] error in
        guard let self = self else { return }
        emit(signal: self.signal, "Error: \(error)")
    }
    
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = [.fullName, .email]
    
    // Critical: prepare the request with the nonce
    signInDelegate?.prepareRequest(request)
    
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = signInDelegate
    controller.presentationContextProvider = signInDelegate
    controller.performRequests()
    #else
    emit(signal: self.signal, "Apple sign in is not supported on this platform")
    #endif
}
    
  @Callable
    func checkUserAlreadyLoggedIn() {
        #if os(iOS)
        guard isFirebaseConfigured else {
            emit(signal: signal, "Error: Firebase not configured, call setupFirebase first")
            return
        }
        if let user = Auth.auth().currentUser {
            let output = "\(user.uid) \(user.email ?? "no-email") \(user.displayName ?? "no-name")"
            emit(signal: signal, "User is already authorized with Firebase: \(output)")
            return
        }
        guard let id = UserDefaults.standard.string(forKey: "id") else {
            emit(signal: signal, "show login screen")
            return
        }
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: id) { [weak self] credentialState, error in
            guard let self = self else { return }
            switch credentialState {
            case .authorized:
                emit(signal: self.signal, "Apple credential authorized, but not signed into Firebase")
            case .revoked:
                emit(signal: self.signal, "Sign user out and remove cache and navigate to login screen")
            case .notFound:
                emit(signal: self.signal, "show login screen")
            @unknown default:
                emit(signal: self.signal, "Unknown credential state")
            }
        }
        #else
        emit(signal: signal, "Apple sign in is not supported on this platform")
        #endif
    }

    
   
    
    @Callable
    func signOut() {
        #if os(iOS)
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "id")
            emit(signal: signalTwo, "Signed out from Firebase")
        } catch {
            emit(signal: signal, "Error signing out: \(error.localizedDescription)")
        }
        #endif
    }
}// The Swift Programming Language
// https://docs.swift.org/swift-book
