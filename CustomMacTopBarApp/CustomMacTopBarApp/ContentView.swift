//
//  ContentView.swift
//  CustomMacTopBarApp
//
//  Created by Max on 09.11.24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dateProvider: DateProvider
    @State private var selectedStartDate: Date
    @State private var selectedEndDate: Date
    
    init(dateProvider: DateProvider) {
        self.dateProvider = dateProvider
        _selectedStartDate = State(initialValue: dateProvider.referenceStartDate)
        _selectedEndDate = State(initialValue: dateProvider.referenceEndDate)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: quit) {
                    Label("Quit", systemImage: "xmark.circle.fill")
                }
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
            
            Text("Set Reference Dates")
                .font(.headline)
            
            DatePicker(
                "Start Date:",
                selection: $selectedStartDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .onChange(of: selectedStartDate) { newValue in
                dateProvider.referenceStartDate = newValue
            }
            
            DatePicker(
                "End Date:",
                selection: $selectedEndDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .onChange(of: selectedEndDate) { newValue in
                dateProvider.referenceEndDate = newValue
            }
            
            Spacer()
        }
        .padding()
        .frame(height: 400)
    }
    
    func quit() {
        NSApp.terminate(nil)
    }
}
