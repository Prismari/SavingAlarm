//
//  ContentView.swift
//  SaveAlarm
//
//  Created by Maria Ugorets on 19/01/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Entry]
    
    @State private var showingAlert = false
    @State private var source = ""
    @State private var sum = ""
    
    var body: some View {
        TabView {
            //MARK: first tab
            VStack(alignment: .leading) {
                Text("Nice to see you back!")
                    .font(.largeTitle)
                    
                Text("Already saved:")
                    .font(.title)
                    
                ZStack {
                    CircularProgressView(progress: Double(items.map { $0.sum }.reduce(0, +)))
                        .frame(width: 250, height: 250, alignment: .center)
                        .padding(40)
                    Text("\(items.map { $0.sum }.reduce(0, +), format: .currency(code: "USD"))")
                        .bold()
                        .font(.largeTitle)
                }
                .background(Color.secondaryBackground)
                .cornerRadius(50)
                
            }
            
            .tabItem {
                Label("Savings",
                      systemImage: "1.circle")
            }
            
            //MARK: second tab
            NavigationSplitView {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            VStack {
                                Text("Entry from \(item.source)")
                                Text("Added at \(item.timestamp, format: Date.FormatStyle(date: .abbreviated, time: .shortened))")
                                Text("\(item.sum, format: .currency(code: "USD"))")
                            }
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem {
                        Button("Add new") {
                            showingAlert.toggle()
                        }
                        .popover(isPresented: $showingAlert) {
                            FormView()
                        }
                    }
                }
            } detail: {
                Text("Select an item")
            }
            .tabItem {
                Label("Entries",
                      systemImage: "2.circle")
            }
            
            
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Entry.self, inMemory: true)
}

//#Preview {
//    FormView()
//}


struct CircularProgressView: View {
    // 1
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.black.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
                // 2
                .trim(from: 0, to: progress / 10000)
                .stroke(
                    Color.black,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

struct FormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var source = SourceOfMoney.appoalimStocks
    @State private var sum = "100"
    
    @FocusState private var sumIsFocused: Bool

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Input Amount")) {
                    TextField("Sum in USD", text: $sum)
                        .keyboardType(.decimalPad)
                        .focused($sumIsFocused)
                }
                Section(header: Text("Where it's stored")) {
                    Picker("Select", selection: $source) {
                        Text("Apoalim stocks").tag(SourceOfMoney.appoalimStocks)
                        Text("Binance").tag(SourceOfMoney.binance)
                        Text("Kupat").tag(SourceOfMoney.kupatGemelHaAshka)
                        Text("USD Appoalim").tag(SourceOfMoney.appoalimCurrency)
                    }
                    .foregroundStyle(.quinaryBackground)
                }
                
            }
            Button("Done") {
                sumIsFocused = false
                let newEntry = Entry(timestamp: .now,
                                     source: source,
                                     sum: Int(sum) ?? 0)
                
                modelContext.insert(newEntry)
                dismiss()
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.quaternaryBackground)
        }
    }
}


struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        
            content.scrollContentBackground(.hidden)
    }
}
