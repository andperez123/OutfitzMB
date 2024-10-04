import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Profile")) {
                    Text("Profile")
                        .font(.headline)  // Corrected the typo here
                }
                NavigationLink(destination: Text("Settings")) {
                    Text("Settings")
                        .font(.headline)
                }
            }
            .navigationBarTitle("Dashboard")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
