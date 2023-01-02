//
//  ContactsCoreData.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import SwiftUI

@main
struct ContactsCoreData: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
        }
    }
}
