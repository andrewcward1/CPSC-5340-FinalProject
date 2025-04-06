//
//  AuthenticationViewModel.swift
//  RaiderIO
//
//  Created by Andrew Ward on 4/6/25.
//

//This viewmodel is courtesy of Firebase documentation. Credit to Peter Friese and Google.
//references: https://www.youtube.com/watch?v=q-9lx7aSWcc
//https://github.com/FirebaseExtended/firebase-video-samples/blob/main/fundamentals/apple/auth-gettingstarted/starter/Favourites/Shared/Auth/AuthenticationView.swift


import Foundation
import FirebaseAuth

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var confirmPassword: String = ""

  @Published var flow: AuthenticationFlow = .login

  @Published var isValid: Bool  = false
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var user: User?
  @Published var errorMessage: String = ""
  @Published var displayName: String = ""

  init() {
    registerAuthStateHandler()

    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
          ? !(email.isEmpty || password.isEmpty)
          : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)
  }

  func registerAuthStateHandler() {
  }

  func switchFlow() {
    flow = flow == .login ? .signUp : .login
    errorMessage = ""
  }

  private func wait() async {
    do {
      print("Wait")
      try await Task.sleep(nanoseconds: 1_000_000_000)
      print("Done")
    }
    catch { }
  }

  func reset() {
    flow = .login
    email = ""
    password = ""
    confirmPassword = ""
  }
}

// MARK: - Email and Password Authentication

extension AuthenticationViewModel {
  func signInWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
      do {
          let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
          user = authResult.user
          authenticationState = .authenticated
          displayName = user?.email ?? "(unknown)"
          return true
      }
      catch {
          print(error)
          errorMessage = error.localizedDescription
          authenticationState = .unauthenticated
          return false
      }
      
      
  }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    await wait()
    authenticationState = .authenticated
    return true
  }

  func signOut() {
    authenticationState = .unauthenticated
  }

  func deleteAccount() async -> Bool {
    authenticationState = .unauthenticated
    return true
  }
}
