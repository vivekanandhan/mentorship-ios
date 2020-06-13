//
//  Home.swift
//  Created on 05/06/20.
//  Created for AnitaB.org Mentorship-iOS 
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
                Section {
                    EmptyView()
                }
                
                //Relation dashboard list
                Section {
                    ForEach(0 ..< relationsData.relationTitle.count) { i in
                        NavigationLink(destination: Text("Hi")) {
                            RelationListCell(
                                systemImageName: self.relationsData.relationImageName[i],
                                imageColor: self.relationsData.relationImageColor[i],
                                title: self.relationsData.relationTitle[i],
                                count: self.relationsData.relationCount[i]
                            )
                                .opacity(self.homeModel.isLoading ? 0.5 : 1.0)
                        }
                    }
                }
                
                //Tasks done list
                Section(header: Text("Tasks Done").font(.headline)) {
                    ForEach(1..<3) { i in
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                                
                                .padding(.trailing, DesignConstants.Padding.insetListCellFrameExpansion)
                            Text("Task \(i) description")
                                .font(.subheadline)
                        }
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
