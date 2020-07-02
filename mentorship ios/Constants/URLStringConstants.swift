//
//  URLConstants.swift
//  Created on 05/06/20.
//  Created for AnitaB.org Mentorship-iOS 
//

let baseURL: String = "https://mentorship-backend-temp.herokuapp.com/"

struct URLStringConstants {
    struct Users {
        static let login: String = baseURL + "login"
        static let signUp: String = baseURL + "register"
        static let members: String = baseURL + "users"
        static let home: String = baseURL + "dashboard"
        static let user: String = baseURL + "user"
        static let changePassword: String = baseURL + "/user/change_password"
    }

    struct MentorshipRelation {
        static let sendRequest: String = baseURL + "mentorship_relation/send_request"
        static let currentRelation: String = baseURL + "/mentorship_relations/current"
        static func getCurrentTasks(id: Int) -> String {
            return baseURL + "mentorship_relation/\(id)/tasks"
        }
    }
    
    struct WebsiteURLs {
        static let privacyPolicy = "https://anitab.org/privacy-policy/"
        static let termsOfUse = "https://anitab.org/terms-of-use/"
    }
}
