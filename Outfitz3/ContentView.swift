import SwiftUI

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var chatResponse: String = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your prompt", text: $userInput)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()

                Button(action: fetchChatResponse) {
                    Text("Get Response")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }

                Text(chatResponse)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("ChatGPT API")
        }
    }
    
    private func fetchChatResponse() {
        APIManager.shared.fetchChatResponse(prompt: userInput) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.chatResponse = response
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
