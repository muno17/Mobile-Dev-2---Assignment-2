import SwiftUI

// Gemini used to help find out how to swipe to delete
// how to add a dropdown for pastas on a selection

struct ContentView: View {
    @State private var orderedItems: [OrderItem] = []
    @State private var tip: Int = 0
    
    // Calculate subtotal automatically from the ordered items array
    private var subtotal: Int {
        orderedItems.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        NavigationStack {
            List {
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
                
                if !orderedItems.isEmpty {
                    Section(header: Text("Current Order")) {
                        ForEach(orderedItems) { item in
                            HStack {
                                Text("\(item.pastaType) \(item.dishName)")
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
                    CostItem(subtotal: subtotal, tip: tip)
                }
                
                Section {
                    ConfirmItem()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(Text("Trattoria Sawi"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

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
            Text("Tip (\(tip)%): $\(tipAmount, specifier: "%.2f")")
            Text("Total: $\(totalAmount, specifier: "%.2f")")
                .bold()
        }
    }
}

struct ListItem: View {
    var iconName: String = "plus"
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
            VStack(alignment: .leading, spacing: 10) {
                Text("Choose your pasta type:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Picker("Pasta Type", selection: $selectedPasta) {
                    ForEach(pastaOptions, id: \.self) { pasta in
                        Text(pasta).tag(pasta)
                    }
                }
                .pickerStyle(.menu)
                
                Button(action: {
                    // Add the customized item to the order list
                    let newItem = OrderItem(pastaType: selectedPasta, dishName: itemName, price: price)
                    orderedItems.append(newItem)
                    isExpanded = false // Collapse after adding
                }) {
                    Text("Add \(selectedPasta) \(itemName) ($\(price))")
                        .font(.subheadline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.vertical, 4)
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .foregroundStyle(Color("theme"))
                
                Text(itemName)
                    .font(.headline)
                
                Spacer()
                
                Text("$\(price)")
                    .bold()
            }
        }
        .padding(.vertical, 4)
    }
}

struct TipItem: View {
    @State private var flag: Bool = false
    @State private var tipSelection: Int = 15
    let tipOptions: [Int] = [10, 15, 20, 25]
    @Binding var tip: Int
    
    var body: some View {
        VStack {
            Toggle("Add a Tip?", isOn: $flag.animation())
                .onChange(of: flag) { _, isEnabled in
                    tip = isEnabled ? tipSelection : 0
                }
            
            if flag {
                Picker("Tip Percentage", selection: $tipSelection) {
                    ForEach(tipOptions, id: \.self) { option in
                        Text("\(option)%").tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical, 4)
                .onChange(of: tipSelection) { _, newValue in
                    tip = newValue
                }
            }
        }
        .onAppear {
            if flag { tip = tipSelection }
        }
    }
}

struct OrderItem: Identifiable, Equatable {
    let id = UUID()
    let pastaType: String
    let dishName: String
    let price: Int
}

struct ConfirmItem: View {
    @State private var present: Bool = false
    
    var body: some View {
        Button("Confirm Order") {
            present.toggle()
        }
        .sheet(isPresented: $present) {
            SecondView(present: $present)
        }
    }
}

struct SecondView: View {
    @Binding var present: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Order Confirmed!")
                .font(.title2)
                .bold()
            Button("Dismiss") {
                present = false
            }
        }
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

