//
//  Home.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 05/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct Home: View {
    @ObservedObject var homeModel = HomeModel()
    private let profile = ProfileModel().getProfile()
    
    private let relationTitles = ["Pending", "Accepted", "Rejected", "Cancelled", "Completed"]
    private let relationImages = ["arrow.2.circlepath.circle.fill", "checkmark.circle.fill", "xmark.circle.fill", "trash.circle.fill", "archivebox.fill"]
    private let relationImageColors = [Color.blue, Color.green, Color.pink, Color.yellow, DesignConstants.Colors.defaultIndigoColor]
    
    var body: some View {
        NavigationView {
            List {
                //Top space
                Section {
                    EmptyView()
                }
                
                //Relation dashboard list
                Section {
                    ForEach(relationTitles, id: \.self) { title in
                        Text(title)
                    }
                    
                }
                
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Welcome \(profile.name?.capitalized ?? "")!")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
