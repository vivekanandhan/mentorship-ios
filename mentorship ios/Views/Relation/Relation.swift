//
//  Relation.swift
//  Created on 30/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct Relation: View {
    //sample data
    @ObservedObject var relationViewModel = RelationViewModel()
    @State var showAlert = false
    @State var addTask  = false
    
    var endDate: Date {
        return Date(timeIntervalSince1970: relationViewModel.currentRelation.endDate ?? 0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    //Top detail view
                    VStack {
                        //mentor/mentee name and end date
                        HStack {
                            Text(relationViewModel.personName).font(.title).fontWeight(.heavy)
                            Spacer()
                            Text("Ends On: \(DesignConstants.DateFormat.mediumDate.string(from: endDate))")
                                .font(.callout)
                        }
                        .foregroundColor(DesignConstants.Colors.subtitleText)
                        
                        //divider, adds a line below name and date
                        Divider()
                            .background(DesignConstants.Colors.defaultIndigoColor)
                    }
                    .listRowBackground(DesignConstants.Colors.formBackgroundColor)
                    
                    //Tasks To Do List section
                    TasksToDoSection(tasksToDo: relationViewModel.toDoTasks) { task in
                        //set tapped task
                        RelationViewModel.taskTapped = task
                        //show alert for marking as complete confirmation
                        self.showAlert.toggle()
                    }
                    
                    //Tasks Done List section
                    TasksDoneSection(tasksDone: relationViewModel.doneTasks)
                }
                .blur(radius: self.addTask ? DesignConstants.Blur.backgroundBlur : 0)
                
                //show add task text field and button
                if self.addTask {
                    AddTask(text: self.$relationViewModel.newTask.description)
                        .padding()
                        .padding(.top)
                }
                
                //show activity spinner if in activity
                if relationViewModel.inActivity {
                    ActivityIndicator(isAnimating: $relationViewModel.inActivity, style: .medium)
                }
            }
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(self.addTask ? LocalizableStringConstants.addTask : "Current Relation")
            .navigationBarItems(trailing: Button(self.addTask ? LocalizableStringConstants.cancel : LocalizableStringConstants.addTask) {
                self.addTask.toggle()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Mark as completed?"),
                    primaryButton: .cancel(),
                    secondaryButton: .default(Text(LocalizableStringConstants.confirm)) {
                        self.relationViewModel.markAsComplete()
                    })
            }
        }
    }
}

struct Relation_Previews: PreviewProvider {
    static var previews: some View {
        Relation()
    }
}
