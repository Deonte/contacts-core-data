//
//  ContactRowView.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import SwiftUI

struct ContactRowView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @ObservedObject var contact: Contact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(contact.formatedName)
                .font(.system(size: 24, design: .rounded))
                .bold()
            
            Text(contact.email)
                .font(.callout.bold())
            
            Text(contact.phoneNumber)
                .font(.callout.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                toggleFavorite()
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundColor(contact.isFavorite ? .yellow : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension ContactRowView {
    func toggleFavorite() {
        contact.isFavorite.toggle()
        do {
            if managedObjectContext.hasChanges {
                try managedObjectContext.save()
            }
        } catch {
            print(error)
        }
    }
}

//struct ContactRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactRowView()
//    }
//}
