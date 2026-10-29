import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var total : Int = 0
    
    var body: some View {
        NavigationStack {
            List{
                Group {
                    ListItem(itemName: "Aglio e Olio", price: 15, total: $total)
                    ListItem(itemName: "Pomodoro", price: 20, total: $total)
                    ListItem(itemName: "Bolognese", price: 25, total: $total)
                    ListItem(itemName: "Cacio e Pepe", price: 18, total: $total)
                    ListItem(itemName: "Puttanesca", price: 20, total: $total)
                    ListItem(itemName: "Carbonara", price: 25, total: $total)
                    ListItem(itemName: "Arrabiata", price: 23, total: $total)
                    ListItem(itemName: "Pasta alle Vongole", price: 35, total: $total)
                    ListItem(itemName: "Pasta al Tonno", price: 28, total: $total)
                }
                Section {
                    ActionItem()
                }
                Section {
                    PickerItem()
                }
                Section {
                    ConfirmItem()
                }
                Section {
                    TotalItem(total: $total)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(Text("Trattoria Sawi"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TotalItem: View {
    @Binding var total : Int
    
    var body: some View {
        HStack {
            Text("Subtotal: $\(total)")
        }
    }
}


struct PastaItem: View {
    var body: some View {
        List {
            "Test"; "Test 2"
        }
    }
}

struct ListItem: View {
    var iconName : String = "plus"
    var itemName : String
    var price : Int
    @Binding var total : Int
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .imageScale(.large)
                .onTapGesture {
                    total += price
                }
            Text(itemName)
            Spacer()
            Text("$\(price)")
        }
        .padding()
        .foregroundStyle(Color("theme"))
        .onTapGesture {
            
        }
    }
}

struct ActionItem : View {
    @State var counter : Int = 0
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .imageScale(.large)
                .onTapGesture {
                    counter += 1
                }
            Spacer()
            Text("\(counter)")
        }
    }
}

struct PickerItem : View {
    @State var flag : Bool = false
    @State var tip : Int = 0
    var tipOptions : [Int] = [10, 15, 20, 25]
    
    var body: some View {
        VStack {
            Toggle("Add a Tip?", isOn: $flag.animation())
            
            if flag {
                Picker("Tip Percentage", selection: $tip) {
                    ForEach(tipOptions, id: \.self) {option in
                        Text("\(option)%")}
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
        }
    }
}

struct ConfirmItem : View {
    @State var present : Bool = false
    
    var body: some View {
        Button("Confirm Order") {
            present.toggle()
        }
        .sheet(isPresented: $present, content: {
            SecondView(present: $present)
        })
    }
}

struct SecondView: View {
    @Binding var present: Bool
    
    var body: some View {
        VStack{
            Text("Order Confirmed!")
            Button("Dismiss") {
                present.toggle()
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

