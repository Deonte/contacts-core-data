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
    
    @State private var hasError: Bool = false
    
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
        .navigationTitle(viewModel.isNew ? "New Contact" : "Edit Contact")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    validate()
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Something Went Wrong", isPresented: $hasError) {
            
        } message: {
            Text("It looks like your form is invalid.")
        }

    }
}

private extension CreateContactView {
    func validate() {
        if viewModel.contact.isValid {
            do {
                try viewModel.save()
                dismiss()
            } catch {
                print(error)
            }
        } else {
            hasError = true
        }
    }
}

struct CreateContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let preview = ContactsProvider.shared
            CreateContactView(viewModel: .init(provider: preview))
                .environment(\.managedObjectContext, preview.viewContext)
            
        }
    }
}
