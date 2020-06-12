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
    var relationsData: HomeModel.RelationsListData {
        return homeModel.relationsListData
    }
    private let profile = ProfileModel().getProfile()
    
    var body: some View {
        NavigationView {
            List {
                //Top space
//                Section {
//                    EmptyView()
//                }
                
                //Relation dashboard list
                Section {
                    ForEach(0..<5) { i in
                        RelationListCell(
                            systemImageName: self.relationsData.relationImageName[i],
                            imageColor: self.relationsData.relationImageColor[i],
                            title: self.relationsData.relationTitle[i],
                            count: self.relationsData.relationCount[i]
                        )
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
