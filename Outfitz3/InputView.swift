import SwiftUI
import Foundation

// Add this import if APIManager is in a different file
// import YourProjectName

extension Binding where Value == String? {
    func orEmpty() -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? "" },
            set: { self.wrappedValue = $0 }
        )
    }
}

struct InputView: View {
    @State private var additionalPreferences: String = ""
    @State private var selectedGender: String? = nil
    @State private var userInput: String = ""
    @State private var selectedEvent: String? = nil
    @State private var selectedStyle: String? = nil
    @State private var selectedMainClothingPiece: String? = nil
    @State private var selectedDetails: String? = nil
    @State private var selectedAccessory: String? = nil
    @State private var selectedColorPalette: String? = nil
    @State private var outfitTitle: String = ""
    @State private var navigateToGeneratedOutfits: Bool = false
    @State private var generatedImages: [String] = []
    @State private var generatedText: String = ""
    @State private var isLoading: Bool = false
    
    @Environment(\.colorScheme) var colorScheme // Detect Dark Mode

    // Default options if no gender is selected or "Other" is selected
    let defaultEvents = ["Casual brunch", "Business event", "Formal evening", "Outdoor event", "Social gathering"]
    let defaultStyles = ["Classic", "Modern", "Comfortable", "Trendy", "Casual"]
    let defaultMainClothingPieces = ["Suit", "Jeans and top", "Dress", "Athletic wear", "Jacket and pants"]
    let defaultDetails = ["Minimalist", "Bold patterns", "Comfortable fit", "Layered look", "Understated"]
    let defaultAccessories = ["Watch", "Bag", "Sunglasses", "Hat", "Jewelry"]
    let defaultColorPalettes = ["Bright", "Neutral", "Dark", "Monochrome", "Earthy"]
    let eventsMale = ["Casual brunch with friends", "Business conference", "Formal evening gala", "Outdoor summer party", "Date night"]
    let eventsFemale = ["Ladies brunch", "Business conference", "Evening gala", "Summer garden party", "Romantic dinner"]

    let stylesMale = ["Classic and timeless", "Modern and edgy", "Sporty and comfortable", "Streetwear and trendy", "Business casual"]
    let stylesFemale = ["Chic and elegant", "Bold and daring", "Comfortable and relaxed", "Trendy and fashionable", "Professional and polished"]

    let mainClothingPiecesMale = ["Tailored suit", "Casual jeans and t-shirt", "Smart casual shirt and chinos", "Athletic wear", "Jacket and trousers"]
    let mainClothingPiecesFemale = ["Cocktail dress", "Jeans and blouse", "Smart casual dress", "Athletic wear", "Blazer and skirt"]

    let detailsMale = ["Sharp lines and minimal embellishments", "Bold patterns and statement accessories", "Comfortable fit and practical design", "Layered looks with varied textures", "Simple and understated elegance"]
    let detailsFemale = ["Delicate details and lace", "Bold patterns and statement jewelry", "Comfortable fit with a touch of style", "Layered look with scarves", "Simple and understated chic"]

    let accessoriesMale = ["Cufflinks and tie", "Stylish watch", "Sunglasses", "Hat or cap", "Bracelet or ring"]
    let accessoriesFemale = ["Necklace and earrings", "Stylish handbag", "Sunglasses", "Hat or hair accessory", "Bracelet or ring"]

    let colorPalettesMale = ["Bright and bold colors", "Neutral tones", "Dark and moody", "Monochromatic", "Earthy and natural shades"]
    let colorPalettesFemale = ["Pastels and light shades", "Neutral tones", "Dark and moody", "Monochromatic", "Earthy and floral shades"]

    private var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("OPENAI_API_KEY not set in environment variables")
        }
        return apiKey
    }
 
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) { // Increased spacing for better layout
                        // Title Section
                        Text("Find your Fitz")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        
                        // Gender Picker Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Select Gender")
                                .font(.headline)
                                .foregroundColor(.white)

                            Menu {
                                Picker(selection: $selectedGender, label: Text("")) {
                                    ForEach(["Male", "Female", "Other"], id: \.self) { gender in
                                        Text(gender).tag(gender as String?)
                                    }
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    Text(selectedGender?.isEmpty == false ? selectedGender! : "Pick one (optional)")
                                        .foregroundColor(.white)
                                        .font(.body)
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue.opacity(0.7))
                                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Text Input Field for additional preferences
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Describe Your Fit")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextEditor(text: $additionalPreferences)
                                .frame(height: 100)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.15))
                                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                                )
                                .foregroundColor(colorScheme == .dark ? .white : .black) // Adjust text color based on mode
                                .font(.body)
                        }
                        .padding(.horizontal)
                        
                        // Multiple Choice Questions with centered alignment and improved contrast
                        VStack(spacing: 15) {
                            StylePicker(
                                title: "What event are you attending?",
                                selection: $selectedEvent, // Binding<String?>
                                items: selectedGender == "Male" ? eventsMale : (selectedGender == "Female" ? eventsFemale : defaultEvents)
                            )
                            StylePicker(
                                title: "How would you describe your personal style?",
                                selection: $selectedStyle, // Binding<String?>
                                items: selectedGender == "Male" ? stylesMale : (selectedGender == "Female" ? stylesFemale : defaultStyles)
                            )
                            StylePicker(
                                title: "What is your main clothing piece?",
                                selection: $selectedMainClothingPiece, // Binding<String?>
                                items: selectedGender == "Male" ? mainClothingPiecesMale : (selectedGender == "Female" ? mainClothingPiecesFemale : defaultMainClothingPieces)
                            )
                            StylePicker(
                                title: "Any specific details or features?",
                                selection: $selectedDetails, // Binding<String?>
                                items: selectedGender == "Male" ? detailsMale : (selectedGender == "Female" ? detailsFemale : defaultDetails)
                            )
                            StylePicker(
                                title: "What accessories will you wear?",
                                selection: $selectedAccessory, // Binding<String?>
                                items: selectedGender == "Male" ? accessoriesMale : (selectedGender == "Female" ? accessoriesFemale : defaultAccessories)
                            )
                            StylePicker(
                                title: "What color palette do you prefer?",
                                selection: $selectedColorPalette, // Binding<String?>
                                items: selectedGender == "Male" ? colorPalettesMale : (selectedGender == "Female" ? colorPalettesFemale : defaultColorPalettes)
                            )
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity) // Ensure the VStack is centered within the screen
                        .alignmentGuide(.leading) { _ in 0 } // Center content within VStack
                        
                        // Improved Call-to-Action Button
                        Button(action: generateOutfit) {
                            Text("Generate My Fit")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.9), Color.pink.opacity(0.9)]),
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                        .disabled(isLoading)
                    }
                    .frame(maxWidth: .infinity) // Ensures all content is centered horizontally
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: ViewSizeKey.self, value: geometry.size)
                })
                .onPreferenceChange(ViewSizeKey.self) { size in
                    print("ScrollView content size: \(size)")
                }
                
                if isLoading {
                    LoadingView()
                }
            }
            .navigationDestination(isPresented: $navigateToGeneratedOutfits) {
                GeneratedOutfitsView(
                    generatedImages: generatedImages,
                    generatedText: generatedText, // Ensure this is the API-generated description
                    occasion: selectedEvent ?? "No event specified",
                    style: selectedStyle ?? "No style specified",
                    colors: selectedColorPalette ?? "No color palette specified",
                    additionalPreferences: additionalPreferences,
                    mainClothingPiece: selectedMainClothingPiece ?? "No main clothing piece specified",
                    details: selectedDetails ?? "No details specified",
                    accessories: selectedAccessory ?? "No accessories specified"
                )
            }
        }
    }

               
    struct CustomButtonStyle: ButtonStyle {
        var isLoading: Bool = false

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.8), Color.pink.opacity(0.8)]),
                                   startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .opacity(isLoading ? 0.5 : 1.0)  // Dim the button if loading
                .overlay(
                    Group {
                        if isLoading {
                            ProgressView()  // Loading indicator
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                )
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        }
    }
    struct StylePicker: View {
        let title: String
        @Binding var selection: String?
        let items: [String]

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.leading, 10)

                Menu {
                    Picker(selection: Binding(
                        get: { self.selection ?? "" },
                        set: { self.selection = $0.isEmpty ? nil : $0 }
                    ), label: Text("")) {
                        ForEach(items, id: \.self) { item in
                            Text(item).tag(item as String?)
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(selection?.isEmpty == false ? selection! : "Pick one (optional)")
                            .foregroundColor(.white)
                            .font(.body)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0, green: 0, blue: 1, opacity: 0.7))                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    
    struct CustomStylePicker: View {
            let title: String
            @Binding var selection: String
            let items: [String]

            var body: some View {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Picker(selection: $selection, label: Text("")) {
                        ForEach(items, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)
            }
    }
    
    func generateOutfit() {
        print("Generate Outfit button pressed")
        self.isLoading = true
        
        let textPrompt = """
        You are a fashion assistant that designs outfits. Based on the following user input, generate a stylish outfit:
        User Input: "\(additionalPreferences)"

        Consider the following details:
        1. Gender: \(selectedGender?.isEmpty == false ? selectedGender! : "Not specified")
        2. Event: \(selectedEvent?.isEmpty == false ? selectedEvent! : "Not specified")
        3. Style Preference: \(selectedStyle?.isEmpty == false ? selectedStyle! : "Not specified")
        4. Color Palette: \(selectedColorPalette?.isEmpty == false ? selectedColorPalette! : "Not specified")
        5. Main Clothing Piece: \(selectedMainClothingPiece?.isEmpty == false ? selectedMainClothingPiece! : "Not specified")
        6. Details: \(selectedDetails?.isEmpty == false ? selectedDetails! : "Not specified")
        7. Accessories: \(selectedAccessory?.isEmpty == false ? selectedAccessory! : "Not specified")

        Create a detailed outfit description suitable for the occasion, considering the season and environment. Describe the fit, material, and style of each clothing piece, including any relevant details like patterns or textures. Ensure the colors complement each other based on the selected color palette.

        Also, provide a separate DALL-E prompt that accurately describes this outfit on a person in a suitable setting.
        """
        
        let schema: [String: Any] = [
            "type": "object",
            "properties": [
                "outfit": ["type": "string"],
                "breakdown": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "item": ["type": "string"],
                            "description": ["type": "string"]
                        ]
                    ]
                ],
                "dalle_prompt": ["type": "string"]
            ],
            "required": ["outfit", "breakdown", "dalle_prompt"]
        ]
        
        makeTextRequest(with: textPrompt, schema: schema) { result in
            if let description = result {
                DispatchQueue.main.async {
                    self.generatedText = description
                }

                if let jsonData = description.data(using: .utf8),
                   let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let outfit = jsonObject["outfit"] as? String,
                   let dallePrompt = jsonObject["dalle_prompt"] as? String {
                    self.generateImage(outfit: outfit, dallePrompt: dallePrompt)  // Pass both outfit and dallePrompt
                } else {
                    print("Failed to parse outfit description and DALL-E prompt")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("Failed to generate outfit description")
                    self.isLoading = false
                }
            }
        }
    }
    
    private func makeTextRequest(with prompt: String, schema: [String: Any], completion: @escaping (String?) -> Void) {
        let apiURL = "https://api.openai.com/v1/chat/completions"
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "model": "gpt-4o-2024-08-06",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ],
            "functions": [
                [
                    "name": "generate_outfit",
                    "parameters": schema
                ]
            ],
            "function_call": ["name": "generate_outfit"],
            "max_tokens": 1000  // Increase the max_tokens to allow for a longer response
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON payload: \(error)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Full JSON response: \(jsonResponse)")

                    if let choices = jsonResponse["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let functionCall = message["function_call"] as? [String: Any],
                       let argumentsString = functionCall["arguments"] as? String {
                        
                        // Parse the arguments JSON string
                        if let argumentsData = argumentsString.data(using: .utf8),
                           let arguments = try? JSONSerialization.jsonObject(with: argumentsData, options: []) as? [String: Any] {
                            
                            // Extract the outfit description, breakdown, and DALL-E prompt
                            if let outfit = arguments["outfit"] as? String,
                               let breakdown = arguments["breakdown"] as? [[String: String]],
                               let dallePrompt = arguments["dalle_prompt"] as? String {
                                
                                print("Outfit: \(outfit)")
                                print("Breakdown: \(breakdown)")
                                print("DALL-E Prompt: \(dallePrompt)")
                                
                                // Use both the outfit description and DALL-E prompt
                                self.generateImage(outfit: outfit, dallePrompt: dallePrompt)
                            } else {
                                print("Unexpected JSON structure in function_call arguments")
                                completion(nil)
                            }
                        } else {
                            print("Failed to parse function_call arguments")
                            completion(nil)
                        }
                    } else {
                        print("Unexpected JSON response format")
                        completion(nil)
                    }
                } else {
                    print("Unexpected JSON response structure")
                    completion(nil)
                }
            } catch {
                print("Failed to parse JSON response: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }
    


    private func generateImage(outfit: String, dallePrompt: String) {
        print("Outfit Description: \(outfit)")
        print("DALL-E Prompt: \(dallePrompt)")
        makeDalleRequest(with: dallePrompt) { result in
            DispatchQueue.main.async {
                if let imageUrl = result {
                    self.generatedImages = [imageUrl]
                    self.navigateToGeneratedOutfits = true
                } else {
                    print("Failed to generate image")
                }
                self.isLoading = false  // Stop loading only after the image is generated
            }
        }
    }

    private func makeDalleRequest(with prompt: String, completion: @escaping (String?) -> Void) {
        let apiURL = "https://api.openai.com/v1/images/generations"
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with request: \(error)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(nil)
                return
            }
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                print("Non-200 HTTP response code: \(httpResponse.statusCode)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            print("Received data: \(String(data: data, encoding: .utf8) ?? "No data")")
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]],
                   let url = dataArray.first?["url"] as? String {
                    print("Received image URL: \(url)")
                    completion(url)
                } else {
                    print("Expected 'data' key in JSON response")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

// Add this struct outside of your view
struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
