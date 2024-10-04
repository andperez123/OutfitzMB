import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Background Gradient to match your app's style
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) { // Balanced spacing for content
                Text("Generating Outfit...")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            .padding()
        }
    }
}
