//
//  Contact.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import CoreData

final class Contact: NSManagedObject {
    @NSManaged var dob: Date
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var phoneNumber: String
    @NSManaged var notes: String
    @NSManaged var isFavorite: Bool
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date.now, forKey: "dob")
        setPrimitiveValue(false, forKey: "isFavorite")
    }
}
