//
//  WelcomeScreen.swift
//  Gym Partner
//
//  Created by Shashiraj Walsetwar on 11/16/24.
//

import SwiftUI

struct WelcomeScreen: View {
    @AppStorage("isFirstTimeUser") private var isFirstTimeUser: Bool = true
    @AppStorage("username") private var username: String = ""

    @State private var enteredName: String = ""

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                // Logo
                Image(systemName: "dumbbell.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.purple)
                    .background(
                        Circle()
                            .fill(Color.purple.opacity(0.3))
                            .frame(width: 150, height: 150)
                            .shadow(color: .purple, radius: 10, x: 0, y: 5)
                    )

                // Title
                Text("Welcome to FitTrack")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                // Subtitle
                Text("Let's start your fitness journey together")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))

                // Name Input
                TextField("What should we call you?", text: $enteredName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                    )
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)

                // Get Started Button
                Button(action: {
                    username = enteredName
                    isFirstTimeUser = false
                }) {
                    HStack {
                        Text("Get Started")
                            .font(.headline)
                            .bold()
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                    .shadow(color: .blue.opacity(0.5), radius: 5, x: 0, y: 5)
                }
                .disabled(enteredName.isEmpty)
                .opacity(enteredName.isEmpty ? 0.6 : 1.0)
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}

