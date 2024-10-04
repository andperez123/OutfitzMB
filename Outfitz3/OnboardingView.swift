import SwiftUI

struct OnboardingView: View {
    @State private var navigateToInputView = false
    @State private var currentPlaceholderIndex = 0
    @State private var userPrompt: String = ""
    @State private var isPulsing = false
    
    let placeholders = ["What are you dressing for?", "What's your style?", "What should I wear tonight?"]

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient with subtle texture
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.9), Color.purple.opacity(0.7), Color.purple.opacity(0.5)]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        // Subtle abstract pattern
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.05)
                            .rotationEffect(.degrees(45))
                            .offset(x: -150, y: -250)
                    )

                // Content Overlay
                VStack {
                    Spacer()

                    VStack(spacing: 16) {
                        // App Logo
                        Image("appLogo") // Make sure "appLogo" matches your asset name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100) // Adjust size as needed
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

                        Text("Outfitz")
                            .font(.custom("Poppins-Bold", size: 36))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)

                        Text("One Tap to Your Perfect Fit")
                            .font(.custom("Nunito-Regular", size: 18))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                        
                        // Optional: Subtext or additional description
                        Text("Discover Your Unique Style Instantly")
                            .font(.custom("Nunito-Light", size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                        
                        // Placeholder Text Field
                        TextField(placeholders[currentPlaceholderIndex], text: $userPrompt)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .onAppear {
                                // Rotate placeholders
                                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                                    currentPlaceholderIndex = (currentPlaceholderIndex + 1) % placeholders.count
                                }
                            }
                    }
                    .padding(.horizontal)

                    Spacer()

                    Button(action: {
                        navigateToInputView = true
                    }) {
                        Text("Start Styling")
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.teal]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                            .scaleEffect(isPulsing ? 1.05 : 1.0) // Scale effect for pulsing
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            isPulsing = true
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToInputView) {
                InputView()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
