//
//  ContactsListView.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import SwiftUI

struct SearchConfig: Equatable {
    enum Filter {
        case all, favorites
    }
    var query: String = ""
    var filter: Filter = .all
}

enum Sort {
    case ascending, descending
}
struct ContactsListView: View {
    @FetchRequest(fetchRequest: Contact.all()) private var contacts
    @State private var contactToEdit: Contact?
    @State private var searchConfig: SearchConfig = .init()
    @State private var sort: Sort = .ascending
    
    var provider = ContactsProvider.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                if contacts.isEmpty {
                    NoContactsView()
                        .scaleEffect(0.8)
                } else {
                    contactList
                }
            }
            .searchable(text: $searchConfig.query)
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        contactToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section {
                            Text("Filter")
                            Picker(selection: $searchConfig.filter) {
                                Text("All").tag(SearchConfig.Filter.all)
                                Text("Favorites").tag(SearchConfig.Filter.favorites)
                            } label: {
                                Text("Filter Favorites")
                            }
                        }
                        Section {
                            Text("Sort")
                            Picker(selection: $sort) {
                                Label("Ascending", systemImage: "arrow.up").tag(Sort.ascending)
                                Label("Descending", systemImage: "arrow.down").tag(Sort.descending)
                            } label: {
                                Text("Sort Contacts")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                            .font(.title2)
                    }
                }
            }
            .sheet(item: $contactToEdit, onDismiss: {
                contactToEdit = nil
            }, content: { contact in
                NavigationStack {
                    CreateContactView(viewModel: .init(provider: provider, contact: contact))
                }
            })
            .onChange(of: searchConfig) { newConfig in
                contacts.nsPredicate = Contact.filter(with: newConfig)
            }
            .onChange(of: sort) { newSort in
                contacts.nsSortDescriptors = Contact.sort(order: newSort)
            }
        }
    }
}

private extension ContactsListView {
    var contactList: some View {
        List {
            ForEach(contacts) { contact in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: ContactDetailView(contact: contact)) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    ContactRowView(contact: contact, provider: provider)
                        .swipeActions(allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                do {
                                    try provider.delete(contact, in: provider.newContext)
                                } catch {
                                    print(error)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            Button {
                                contactToEdit = contact
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.gray)
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let preview = ContactsProvider.shared
        ContactsListView(provider: preview)
            .environment(\.managedObjectContext, preview.viewContext)
            .previewDisplayName("Contacts With Data")
            .onAppear { Contact.makePreview(count: 10, in: preview.viewContext) }
        
        let emptyPreview = ContactsProvider.shared
        ContactsListView(provider: preview)
            .environment(\.managedObjectContext, emptyPreview.viewContext)
            .previewDisplayName("Contacts With No Data")
    }
}
