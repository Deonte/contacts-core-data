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
    
    var formatedName: String {
        "\(isBirthday ? "🎈" : "")\(name)"
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
    
}
