//
//  Home.swift
//  Created on 05/06/20.
//  Created for AnitaB.org Mentorship-iOS
//

import SwiftUI

struct Home: View {
    @ObservedObject var homeModel = HomeModel()
    private var relationsData: HomeModel.RelationsListData {
        return homeModel.relationsListData
    }
    private var profile: ProfileModel.ProfileData {
        return homeModel.profileData
    }

    var body: some View {
        NavigationView {
            List {
                //Top space
                Section {
                    EmptyView()
                }

                //Relation dashboard list
                Section {
                    ForEach(0 ..< relationsData.relationTitle.count) { index in
                        NavigationLink(destination: RelationDetailList(
                            index: index,
                            navigationTitle: self.relationsData.relationTitle[index],
                            homeResponseData: self.homeModel.homeResponseData
                        )) {
                            RelationListCell(
                                systemImageName: self.relationsData.relationImageName[index],
                                imageColor: self.relationsData.relationImageColor[index],
                                title: self.relationsData.relationTitle[index],
                                count: self.relationsData.relationCount[index]
                            )
                                .opacity(self.homeModel.isLoading ? 0.5 : 1.0)
                        }
                    }
                }

                //Tasks to-do list
                Section(header: Text("Tasks To Do").font(.headline)) {
                    ForEach(homeModel.homeResponseData.tasksToDo ?? []) { task in
                        HStack {
                            Image(systemName: "circle")
                                .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                                .padding(.trailing, DesignConstants.Padding.insetListCellFrameExpansion)
                            
                            Text(task.description ?? "-")
                                .font(.subheadline)
                        }
                    }
                }
                
                //Tasks done list
                Section(header: Text("Tasks Done").font(.headline)) {
                    ForEach(homeModel.homeResponseData.tasksDone ?? []) { task in
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                                .padding(.trailing, DesignConstants.Padding.insetListCellFrameExpansion)
                            
                            Text(task.description ?? "-")
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
