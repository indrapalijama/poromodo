//
//  Profile.swift
//  Poromodo
//
//  Created by Samudra Palijama on 15/09/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var pomodoroTimer: PoromodoTimer
    @State private var username: String = "Samudra Palijama"
    @State private var email: String = "samudra@palijama.com"
    @State private var notificationsEnabled: Bool = false
    @State private var darkModeEnabled: Bool = false
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("User Information")) {
                        TextField("Username", text: $username)
                        TextField("Email", text: $email)
                    }
                    
                    Section(header: Text("Preferences")) {
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        Toggle("Dark Mode", isOn: $darkModeEnabled)
                    }
                    
                    Section {
                        Button("Save Changes") {
                            print("Changes saved")
                        }
                        Button("Reset All Activity") {
                            showResetAlert = true
                        }
                    }
                    
                    Section {
                        Button("Log Out") {
                            print("User logged out")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .background(Color.blue) // Set background color here
            .navigationTitle("Profile")
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("Confirm Reset"),
                    message: Text("Are you sure you want to reset all activities? This action cannot be undone."),
                    primaryButton: .destructive(Text("Reset")) {
                        pomodoroTimer.resetActivity()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    ProfileView(pomodoroTimer: PoromodoTimer())
}
