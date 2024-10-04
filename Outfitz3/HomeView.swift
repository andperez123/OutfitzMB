import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image("appLogo") // Replace with the name of your image in the Assets folder
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200, maxHeight: 200) // Adjust size as needed
                .padding()

            Text("Welcome to Outfitz")
                .font(.largeTitle)
                .padding()

            // Add other UI elements for your home screen
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
