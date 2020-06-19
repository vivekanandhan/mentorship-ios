//
//  SendRequest.swift
//  Created on 09/06/20.
//  Created for AnitaB.org Mentorship-iOS
//

import SwiftUI
import Combine

struct SendRequest: View {
    @ObservedObject var membersModel = MembersModel()
    var memberID: Int
    var memberName: String
    @State private var pickerSelection = 1
    @State private var endDate = Date()
    @State private var notes = ""
    @State private var offsetValue: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode

    func sendRequest() {
        let myID = ProfileModel().getProfile().id
        let endDateTimestamp = self.endDate.timeIntervalSince1970
        var menteeID = myID
        var mentorID = memberID
        if pickerSelection == 2 {
            menteeID = memberID
            mentorID = myID
        }
        membersModel.sendRequest(menteeID: menteeID, mentorID: mentorID, endDate: endDateTimestamp, notes: notes)
    }

    var body: some View {
        NavigationView {
            Form {
                //heading
                Section(header: Text("To \(memberName)").font(.title).fontWeight(.heavy)) {
                    EmptyView()
                }

                //settings
                Section {
                    Picker(selection: $pickerSelection, label: Text("My Role")) {
                        Text(LocalizableStringConstants.mentee).tag(1)
                        Text(LocalizableStringConstants.mentor).tag(2)
                    }

                    DatePicker(selection: $endDate, displayedComponents: .date) {
                        Text(LocalizableStringConstants.endDate)
                    }

                    TextField(LocalizableStringConstants.notes, text: $notes)
                }
                .padding(.vertical, DesignConstants.Padding.listCellFrameExpansion)

                //send button
                Section {
                    Button(action: sendRequest) {
                        Text(LocalizableStringConstants.send)
                    }
                }

                //Activity indicator or error text
                if membersModel.inActivity || !(membersModel.sendRequestResponseData.message ?? "").isEmpty {
                    Section {
                        if membersModel.inActivity {
                            ActivityIndicator(isAnimating: $membersModel.inActivity, style: .medium)
                        } else if !membersModel.requestSentSuccesfully {
                            Text(membersModel.sendRequestResponseData.message ?? "")
                                .modifier(ErrorText())
                        }
                    }
                    .listRowBackground(DesignConstants.Colors.formBackgroundColor)
                }
            }
            .modifier(KeyboardAware())
            .navigationBarTitle(LocalizableStringConstants.relationRequest)
            .navigationBarItems(leading: Button(LocalizableStringConstants.cancel, action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
            .alert(isPresented: $membersModel.requestSentSuccesfully) {
                Alert(
                    title: Text(LocalizableStringConstants.success),
                    message: Text(membersModel.sendRequestResponseData.message ?? "Mentorship relation was sent successfully."),
                    dismissButton: .cancel(Text(LocalizableStringConstants.okay), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                )
            }
        }
    }
}

struct SendRequest_Previews: PreviewProvider {
    static var previews: some View {
        SendRequest(memberID: 0, memberName: "demo name")
    }
}
