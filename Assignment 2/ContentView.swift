import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List{
                Group {
                    ListItem(itemName: "Item1", price: 10)
                    ListItem(itemName: "Item2", price: 20)
                    ListItem(itemName: "Item3", price: 30)
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
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(Text("Sawi's House"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ListItem: View {
    var iconName : String = "globe"
    var itemName : String
    var price : Int
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .imageScale(.large)
            Text(itemName)
            Spacer()
            Text("$\(price)")
        }
        .padding()
        .foregroundStyle(Color("theme"))
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
                        Text("\(option)")}
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
