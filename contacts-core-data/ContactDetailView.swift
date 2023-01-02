//
//  ContactDetailView.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/1/23.
//

import SwiftUI

struct ContactDetailView: View {
    var body: some View {
        List {
            Section("General") {
                LabeledContent {
                    Text("Email Here")
                } label: {
                    Text("Email")
                }
                LabeledContent {
                    Text("Phone Number Here")
                } label: {
                    Text("Phone Number")
                }
                LabeledContent {
                    Text("Birthday Here")
                } label: {
                    Text("Birthday")
                }
            }
            
            Section("Notes") {
                Text("")
            }
        }
        .navigationTitle("Name Here")
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactDetailView()
        }
    }
}
