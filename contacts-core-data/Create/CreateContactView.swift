//
//  CreateContactView.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import SwiftUI

struct CreateContactView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: EditContactViewModel
    
    var body: some View {
        List {
            Section("General") {
                TextField("Name", text: $viewModel.contact.name)
                    .keyboardType(.namePhonePad)
                
                TextField("Email", text: $viewModel.contact.email)
                    .keyboardType(.emailAddress)
                
                TextField("Phone Number", text: $viewModel.contact.phoneNumber)
                    .keyboardType(.phonePad)
                
                DatePicker("Birthday", selection: $viewModel.contact.dob, displayedComponents: [.date])
                
                Toggle("Favorite", isOn:  $viewModel.contact.isFavorite)
            }
            
            Section("Notes") {
                TextField("", text:  $viewModel.contact.notes, axis: .vertical)
            }
        }
        .navigationTitle("Name Here")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    do {
                        try viewModel.save()
                        dismiss()
                    } catch {
                        print(error)
                    }
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
            CreateContactView(viewModel: .init(provider: .shared))
        }
    }
}
