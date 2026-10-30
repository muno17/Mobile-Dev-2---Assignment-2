
// Gemini used to help find out how to swipe to delete
// how to add a dropdown for pastas on a selection (DisclosureGroup)

import SwiftUI

// MARK: - Model
struct OrderItem: Identifiable, Equatable {
    let id = UUID()
    let pastaType: String
    let dishName: String
    let price: Int
}

// Custom Wine Color definition for guaranteed contrast
extension Color {
    static let wineRed = Color(red: 0.5, green: 0.1, blue: 0.15)
}

struct ContentView: View {
    @State private var orderedItems: [OrderItem] = []
    @State private var tip: Int = 0
    
    private var subtotal: Int {
        orderedItems.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Welcome Banner
                Section {
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "laurel.leading")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.wineRed)
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
                
                // MARK: - Menu Items
                Group {
                    ListItem(itemName: "Aglio e Olio", price: 15, orderedItems: $orderedItems)
                    ListItem(itemName: "Pomodoro", price: 20, orderedItems: $orderedItems)
                    ListItem(itemName: "Bolognese", price: 25, orderedItems: $orderedItems)
                    ListItem(itemName: "Cacio e Pepe", price: 18, orderedItems: $orderedItems)
                    ListItem(itemName: "Puttanesca", price: 20, orderedItems: $orderedItems)
                    ListItem(itemName: "Carbonara", price: 25, orderedItems: $orderedItems)
                    ListItem(itemName: "Arrabiata", price: 23, orderedItems: $orderedItems)
                    ListItem(itemName: "Pasta alle Vongole", price: 35, orderedItems: $orderedItems)
                    ListItem(itemName: "Pasta al Tonno", price: 28, orderedItems: $orderedItems)
                }
                
                // MARK: - Current Order Summary
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
                
                // MARK: - Tip Section
                Section {
                    TipItem(tip: $tip)
                }
                
                // MARK: - Cost Summary Section
                Section {
                    CostItem(subtotal: subtotal, tip: tip)
                }
                
                // MARK: - Confirmation Section
                Section {
                    ConfirmItem()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(Text("Trattoria Sawi"))
            .navigationBarTitleDisplayMode(.inline)
            .tint(Color.wineRed)
        }
    }
}


struct ListItem: View {
    var itemName: String
    var price: Int
    @Binding var orderedItems: [OrderItem]
    
    let pastaOptions: [String] = [
        "Spaghetti", "Penne", "Rigatoni", "Fettuccine",
        "Farfalle", "Orecchiette", "Fusilli", "Elbows"
    ]
    
    @State private var selectedPasta: String = "Spaghetti"
    @State private var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 12) {
                
                // Clean Picker Row without duplicate labels
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
                    .tint(Color.wineRed)
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
                    .background(Color.wineRed)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .foregroundStyle(Color.wineRed)
                
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
        .listRowBackground(Color.wineRed.opacity(0.04))
    }
}

// MARK: - Tip Selector Component
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

// MARK: - Cost Breakdown Component
struct CostItem: View {
    let subtotal: Int
    let tip: Int
    
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
                .foregroundStyle(Color.wineRed)
        }
    }
}

// MARK: - Confirmation Button Component
struct ConfirmItem: View {
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
            .background(Color.wineRed)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $present) {
            SecondView(present: $present)
        }
    }
}

// MARK: - Order Confirmed Sheet View
struct SecondView: View {
    @Binding var present: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(Color.wineRed)
            
            Text("Order Confirmed!")
                .font(.title2)
                .bold()
                .foregroundStyle(.primary)
            
            Button("Dismiss") {
                present = false
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.wineRed)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
