//
//  ContactsProvider.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import CoreData
import SwiftUI

final class ContactsProvider {
    static let shared = ContactsProvider()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ContactsDataModel")
        if EnvironmentValues.isPreview || Thread.current.isRunningXCTest {
            persistentContainer.persistentStoreDescriptions.first?.url = .init(filePath: "/dev/null")
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
    
    func exists(_ contact: Contact, context: NSManagedObjectContext) -> Contact? {
        try? context.existingObject(with: contact.objectID) as? Contact
    }
    
    func delete(_ contact: Contact, in context: NSManagedObjectContext) throws {
        if let existingContact = exists(contact, context: context) {
            context.delete(existingContact)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

extension Thread {
    var isRunningXCTest: Bool {
      for key in self.threadDictionary.allKeys {
            guard let keyAsString = key as? String else { continue }
            
            if keyAsString.split(separator: ".").contains("xctest") {
                return true
            }
        }
        return false
    }
}
