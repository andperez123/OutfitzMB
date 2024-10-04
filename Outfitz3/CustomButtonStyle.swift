import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var isLoading: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .bold()
            .padding()
            .frame(maxWidth: .infinity)
            .background(isLoading ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(isLoading ? 0.6 : 1.0)
    }
}
