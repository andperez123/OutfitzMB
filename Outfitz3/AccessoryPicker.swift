import SwiftUI

struct AccessoryPicker: View {
    @Binding var selection: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What is your go-to accessory for completing your outfit?")
                .font(.headline)
            roulettePicker(selection: $selection, items: items)
        }
    }

    func roulettePicker(selection: Binding<String>, items: [String]) -> some View {
        GeometryReader { geometry in
            TabView(selection: selection) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                        .padding()
                        .background(selection.wrappedValue == item ? Color.blue.opacity(0.7) : Color.gray.opacity(0.2))
                        .foregroundColor(selection.wrappedValue == item ? .white : .primary)
                        .cornerRadius(8)
                        .frame(width: geometry.size.width * 0.6, height: 50) // Adjusted the width to fit three options
                        .tag(item)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(width: geometry.size.width, height: 100)
        }
        .frame(height: 100)
    }
}
