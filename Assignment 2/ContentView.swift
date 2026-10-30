/*
 The author would like to acknowledge the use of Gemini, a language model developed by Google, in the preparation of this assignment. Gemini was used in the following ways in this assignment:
 - assistance in creating the OrderItem struct with Identifiable, Equatable and UUID() which weren't covered in class
 - assistance in figuring out how to add the functionality to be able to swipe to delete
 - assistance in figuring out how to add a dropdown for the pasta selection (DisclosureGroup with a Picker)
 - assistance in figuring out the closure for resetting once Confirm Order is pressed
 - assistance with styling (colors, icons)
 
 
 Launch Screen image is from https://www.vecteezy.com/free-vector/spaghetti-bowl
 */
 

import SwiftUI

struct OrderItem: Identifiable, Equatable {
    let id = UUID()
    let pastaType: String
    let dishName: String
    let price: Int
}

// Color Schemes
extension Color {
    // light mode
    static let baseWineRed = Color(red: 0.5, green: 0.1, blue: 0.15)
    // dark mode
    static let italianGreen = Color(red: 0.2, green: 0.5, blue: 0.25)
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var orderedItems: [OrderItem] = []
    @State private var tip: Int = 0
    
    private var themeColor: Color {
        colorScheme == .dark ? Color.italianGreen : Color.baseWineRed
    }
    
    private var subtotal: Int {
        orderedItems.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Welcome Banner
                Section {
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "laurel.leading")
                            .font(.system(size: 32))
                            .foregroundStyle(themeColor)
                        Text("Welcome to Trattoria Sawi")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Pick your favorite pasta and sauce")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color.clear)
                
                // Menu Items
                Group {
                    ListItem(itemName: "Aglio e Olio", price: 15, orderedItems: $orderedItems, themeColor: themeColor)
                    ListItem(itemName: "Pomodoro", price: 20, orderedItems: $orderedItems, themeColor: themeColor)
                    ListItem(itemName: "Bolognese", price: 25, orderedItems: $orderedItems, themeColor: themeColor)
                    ListItem(itemName: "Cacio e Pepe", price: 18, orderedItems: $orderedItems, themeColor: themeColor)
                    ListItem(itemName: "Puttanesca", price: 20, orderedItems: $orderedItems, themeColor: themeColor)
                    ListItem(itemName: "Carbonara", price: 25, orderedItems: $orderedItems, themeColor: themeColor)
                    ListItem(itemName: "Arrabiata", price: 23, orderedItems: $orderedItems, themeColor: themeColor)
                    ListItem(itemName: "Pasta alle Vongole", price: 35, orderedItems: $orderedItems, themeColor: themeColor)
                    ListItem(itemName: "Pasta al Tonno", price: 28, orderedItems: $orderedItems, themeColor: themeColor)
                }
                
                // Order Summary
                if !orderedItems.isEmpty {
                    Section(header: Text("Current Order").bold()) {
                        ForEach(orderedItems) { item in
                            HStack {
                                Text("\(item.pastaType) \(item.dishName)")
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text("$\(item.price)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .onDelete { indexSet in
                            orderedItems.remove(atOffsets: indexSet)
                        }
                    }
                }
                
                Section {
                    TipItem(tip: $tip)
                }
                
                Section {
                    CostItem(subtotal: subtotal, tip: tip, themeColor: themeColor)
                }
                
                Section {
                    ConfirmItem(themeColor: themeColor, orderedItems: $orderedItems)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(Text("Trattoria Sawi"))
            .navigationBarTitleDisplayMode(.inline)
            .tint(themeColor)
        }
    }
}

// Menu Items
struct ListItem: View {
    var itemName: String
    var price: Int
    @Binding var orderedItems: [OrderItem]
    var themeColor: Color
    
    let pastaOptions: [String] = [
        "Spaghetti", "Penne", "Rigatoni", "Fettuccine",
        "Farfalle", "Orecchiette", "Fusilli", "Elbows"
    ]
    
    @State private var selectedPasta: String = "Spaghetti"
    @State private var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 12) {
                
                // Picker Row for pasta
                HStack {
                    Text("Choose Shape:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Picker("", selection: $selectedPasta) {
                        ForEach(pastaOptions, id: \.self) { pasta in
                            Text(pasta).tag(pasta)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(themeColor)
                }
                .padding(.top, 4)
                
                // Add Item Button
                Button(action: {
                    let newItem = OrderItem(pastaType: selectedPasta, dishName: itemName, price: price)
                    orderedItems.append(newItem)
                    isExpanded = false
                }) {
                    HStack {
                        Spacer()
                        Text("Add \(selectedPasta) \(itemName) ($\(price))")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(themeColor)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .foregroundStyle(themeColor)
                
                Text(itemName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text("$\(price)")
                    .bold()
                    .foregroundStyle(.primary)
            }
        }
        .padding(.vertical, 2)
        .listRowBackground(themeColor.opacity(0.08))
    }
}

struct TipItem: View {
    @State private var flag: Bool = false
    @State private var atip: Int = 15
    let tipOptions: [Int] = [10, 15, 20, 25]
    @Binding var tip: Int
    
    var body: some View {
        VStack {
            Toggle("Add a Tip?", isOn: $flag.animation())
                .foregroundStyle(.primary)
                .onChange(of: flag) { _, isEnabled in
                    tip = isEnabled ? atip : 0
                }
            
            if flag {
                Picker("Tip Percentage", selection: $atip) {
                    ForEach(tipOptions, id: \.self) { option in
                        Text("\(option)%").tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical, 4)
                .onChange(of: atip) { _, newValue in
                    tip = newValue
                }
            }
        }
        .onAppear {
            if flag { tip = atip }
        }
    }
}

struct CostItem: View {
    let subtotal: Int
    let tip: Int
    var themeColor: Color
    
    private var tipAmount: Double {
        Double(subtotal) * (Double(tip) / 100.0)
    }
    
    private var totalAmount: Double {
        Double(subtotal) + tipAmount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Subtotal: $\(subtotal)")
                .foregroundStyle(.primary)
            Text("Tip (\(tip)%): $\(tipAmount, specifier: "%.2f")")
                .foregroundStyle(.primary)
            Text("Total: $\(totalAmount, specifier: "%.2f")")
                .bold()
                .foregroundStyle(themeColor)
        }
    }
}

struct ConfirmItem: View {
    var themeColor: Color
    @Binding var orderedItems: [OrderItem]
    @State private var present: Bool = false
    
    var body: some View {
        Button(action: { present.toggle() }) {
            HStack {
                Spacer()
                Text("Confirm Order")
                    .bold()
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.vertical, 8)
            .background(themeColor)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $present) {
            ConfirmationView(present: $present, themeColor: themeColor) {
                // Clear the order array when dismissed
                orderedItems.removeAll()
            }
        }
    }
}

struct ConfirmationView: View {
    @Binding var present: Bool
    var themeColor: Color
    var onDismiss: () -> Void // Closure to handle reset
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(themeColor)
            
            Text("Order Confirmed!")
                .font(.title2)
                .bold()
                .foregroundStyle(.primary)
            
            Text("Your food is being prepared.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button("Dismiss") {
                onDismiss() // Triggers the cart reset
                present = false
            }
            .buttonStyle(.borderedProminent)
            .tint(themeColor)
        .padding()
        }
    }
}

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
