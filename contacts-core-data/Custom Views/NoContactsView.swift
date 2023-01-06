//
//  NoContactsView.swift
//  contacts-core-data
//
//  Created by Deonte Kilgore on 1/3/23.
//

import SwiftUI

struct NoContactsView: View {
    var body: some View {
        VStack {
            Text("👀 No Contacts")
                .font(.largeTitle.bold())
                .padding()
            Text("It seems a little empty here create some contacts ☝️")
                .font(.callout)
        }
    }
}

struct NoContactView_Previews: PreviewProvider {
    static var previews: some View {
        NoContactsView()
    }
}
