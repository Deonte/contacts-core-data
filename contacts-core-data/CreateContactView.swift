//
//  CreateContactView.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import SwiftUI

struct CreateContactView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("General") {
                TextField("Name", text: .constant(""))
                    .keyboardType(.namePhonePad)
                
                TextField("Email", text: .constant(""))
                    .keyboardType(.emailAddress)
                
                TextField("Phone Number", text: .constant(""))
                    .keyboardType(.phonePad)
                
                DatePicker("Birthday", selection: .constant(.now), displayedComponents: [.date])
                
                Toggle("Favorite", isOn: .constant(true))
            }
            
            Section("Notes") {
                TextField("", text: .constant(""), axis: .vertical)
            }
        }
        .navigationTitle("Name Here")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

struct CreateContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateContactView()
        }
    }
}
