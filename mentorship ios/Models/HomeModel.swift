//
//  HomeModel.swift
//  Created on 12/06/20.
//  Created for AnitaB.org Mentorship-iOS
//

import SwiftUI
import Combine

final class HomeModel: ObservableObject {
    // MARK: - Variables
    @Published var homeResponseData = HomeResponseData(as_mentor: nil, as_mentee: nil)
    @Published var relationsListData = RelationsListData()
    var profileModel = ProfileModel()
    var isLoading: Bool = false
    private var cancellable: AnyCancellable?
    
    // MARK: - Functions
    init() {
        guard let token = try? KeychainManager.readKeychain() else {
            return
        }
        print(token)
        
        isLoading = true
        
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.home, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.homeResponseData) }
            .combineLatest(
                NetworkManager.callAPI(urlString: URLStringConstants.Users.getProfile, token: token, cachePolicy: .returnCacheDataElseLoad)
                    .receive(on: RunLoop.main)
                    .catch { _ in Just(self.profileModel.profileData) }
            )
            .sink { home, profile in
                print(home)
                print(profile)
                self.profileModel.saveProfile(profile: profile)
                self.updateCount(homeData: home)
                self.isLoading = false
            }
    }
    
    func updateCount(homeData: HomeResponseData) {
        var pendingCount = homeData.as_mentee?.sent?.pending?.count ?? 0
        pendingCount += homeData.as_mentee?.received?.pending?.count ?? 0
        pendingCount += homeData.as_mentor?.sent?.pending?.count ?? 0
        pendingCount += homeData.as_mentor?.received?.pending?.count ?? 0
        
        var acceptedCount = homeData.as_mentee?.sent?.accepted?.count ?? 0
        acceptedCount += homeData.as_mentee?.received?.accepted?.count ?? 0
        acceptedCount += homeData.as_mentor?.sent?.accepted?.count ?? 0
        acceptedCount += homeData.as_mentor?.received?.accepted?.count ?? 0
        
        var rejectedCount = homeData.as_mentee?.sent?.rejected?.count ?? 0
        rejectedCount += homeData.as_mentee?.received?.rejected?.count ?? 0
        rejectedCount += homeData.as_mentor?.sent?.rejected?.count ?? 0
        rejectedCount += homeData.as_mentor?.received?.rejected?.count ?? 0
        
        var cancelledCount = homeData.as_mentee?.sent?.cancelled?.count ?? 0
        cancelledCount += homeData.as_mentee?.received?.cancelled?.count ?? 0
        cancelledCount += homeData.as_mentor?.sent?.cancelled?.count ?? 0
        cancelledCount += homeData.as_mentor?.received?.cancelled?.count ?? 0
        
        var completedCount = homeData.as_mentee?.sent?.completed?.count ?? 0
        completedCount += homeData.as_mentee?.received?.completed?.count ?? 0
        completedCount += homeData.as_mentor?.sent?.completed?.count ?? 0
        completedCount += homeData.as_mentor?.received?.completed?.count ?? 0
        
        self.relationsListData.relationCount = [pendingCount, acceptedCount, rejectedCount, cancelledCount, completedCount]
    }
    
    // MARK: - Structures
    struct HomeResponseData: Decodable {
        let as_mentor: AsMentor?
        struct AsMentor: Decodable {
            let sent: Sent?
            struct Sent: Decodable {
                let accepted: [RequestStructure]?
                let rejected: [RequestStructure]?
                let completed: [RequestStructure]?
                let cancelled: [RequestStructure]?
                let pending: [RequestStructure]?
            }
            let received: Received?
            struct Received: Decodable {
                let accepted: [RequestStructure]?
                let rejected: [RequestStructure]?
                let completed: [RequestStructure]?
                let cancelled: [RequestStructure]?
                let pending: [RequestStructure]?
            }
        }
        
        let as_mentee: AsMentee?
        struct AsMentee: Decodable {
            let sent: Sent?
            struct Sent: Decodable {
                let accepted: [RequestStructure]?
                let rejected: [RequestStructure]?
                let completed: [RequestStructure]?
                let cancelled: [RequestStructure]?
                let pending: [RequestStructure]?
            }
            let received: Received?
            struct Received: Decodable {
                let accepted: [RequestStructure]?
                let rejected: [RequestStructure]?
                let completed: [RequestStructure]?
                let cancelled: [RequestStructure]?
                let pending: [RequestStructure]?
            }
        }
    }
    
    struct RequestStructure: Decodable {
        let id: Int?
        let action_user_id: Int?
        let mentor: Mentor
        struct Mentor: Decodable {
            let id: Int?
            let user_name: String?
        }
        let mentee: Mentee
        struct Mentee: Decodable {
            let id: Int?
            let user_name: String?
        }
        let accept_date: Double?
        let start_date: Double?
        let end_date: Double?
        let notes: String?
    }
    
    struct RelationsListData {
        let relationTitle = [
            "Pending Requests",
            "Accepted Requests",
            "Rejected Requests",
            "Cancelled Relations",
            "Completed Relations"
        ]
        
        let relationImageName = [
            "arrow.2.circlepath.circle.fill",
            "checkmark.circle.fill",
            "xmark.circle.fill",
            "trash.circle.fill",
            "archivebox.fill"
        ]
        
        let relationImageColor: [Color] = [
            .blue,
            .green,
            .pink,
            .gray,
            DesignConstants.Colors.defaultIndigoColor
        ]
        
        var relationCount = [0, 0, 0, 0, 0]
    }
    
}
