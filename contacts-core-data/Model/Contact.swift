//
//  Contact.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import CoreData

final class Contact: NSManagedObject, Identifiable {
    @NSManaged var dob: Date
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var phoneNumber: String
    @NSManaged var notes: String
    @NSManaged var isFavorite: Bool
    
    var isBirthday: Bool {
        Calendar.current.isDateInToday(dob)
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date.now, forKey: "dob")
        setPrimitiveValue(false, forKey: "isFavorite")
    }
    
    var formattedName: String {
        "\(isBirthday ? "🎈" : "")\(name)"
    }
    
    var isValid: Bool {
        !name.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
    }
}


extension Contact {
    
    private static var contactsFetchRequest: NSFetchRequest<Contact> {
        NSFetchRequest(entityName: "Contact")
    }
    
    static func all() -> NSFetchRequest<Contact> {
        let request: NSFetchRequest<Contact> = contactsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Contact.name, ascending: true)
        ]
        return request
    }
    
    static func filter(with config: SearchConfig) -> NSPredicate {
        switch config.filter {
        case .all:
            return config.query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", config.query)
        case .favorites:
            return config.query.isEmpty ? NSPredicate(format: "isFavorite == %@", NSNumber(value: true)) : NSPredicate(format: "name CONTAINS[cd] %@ AND isFavorite == %@", config.query, NSNumber(value: true))
        }
    }
    
    static func sort(order: Sort) -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Contact.name, ascending: order == .ascending)]
    }
}


extension Contact {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Contact] {
        var contacts = [Contact]()
        for i in 0..<count {
            let contact = Contact(context: context)
            contact.name = "item \(i)"
            contact.email = "test_\(i)@mail.com"
            contact.isFavorite = Bool.random()
            contact.phoneNumber = "111-111-111\(i)"
            contact.dob = Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now
            contact.notes = "This is a preview for item \(i)"
            
            contacts.append(contact)
        }
        return contacts
    }
    
    static func preview(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
        return makePreview(count: 1, in: context)[0]
    }
    
    static func empty(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
        return Contact(context: context)
    }
}
