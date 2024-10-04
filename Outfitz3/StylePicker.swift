import SwiftUI

struct StylePicker: View {
    var title: String
    @Binding var selection: String
    var items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) { // Reduced spacing
            Text(title)
                .font(.title2) // Increased font size
                .foregroundColor(.primary)
                .padding(.bottom, 5)

            roulettePicker(selection: $selection, items: items)
        }
        .padding(.horizontal)
        .padding(.top, 5) // Reduced top padding
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
