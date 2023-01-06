//
//  EditContactViewModel.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import Foundation
import CoreData

final class EditContactViewModel: ObservableObject {
    @Published var contact: Contact
    
    private let context: NSManagedObjectContext
    let isNew: Bool
    private let provider: ContactsProvider
    
    init(provider: ContactsProvider, contact: Contact? = nil) {
        self.provider = provider
        self.context = provider.newContext
        if let contact,
           let existingContactCopy = provider.exists(contact, context: context){
            self.contact = existingContactCopy
            self.isNew = false
        } else {
            self.contact = Contact(context: self.context)
            self.isNew = true
        }
    }
    
    func save() throws {
        try provider.persist(in: context)
    }

}
