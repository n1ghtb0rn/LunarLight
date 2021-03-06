//
//  AppStateController.swift
//  LunarLight
//
//  Created by Daniel Falkedal on 2022-04-01.
//

import Foundation
import SwiftUI

class AppManager: ObservableObject {
    
    static let singletonObject = AppManager()
    
    let firestoreFriendModel = FirestoreFriendModel()
    
    let testUser = UserFirebase(
        _id: "490FA39D-0752-4649-B222-E2ABEABC6ECC",
        _username: "test",
        _email: "test@email.se",
        _password: "12345",
        _year: 2010,
        _month: 1,
        _day: 1,
        _avatar: "capricorn_6",
        _profileInfo: "This is me yo")
    
    var loggedInUser: UserFirebase
    var profileUser: UserFirebase?
    var privateChatUser : UserFirebase?
    var coreDataUser: UserCoreData?
    
    @Published var appIndex = AppIndex.startView
    @Published var currentLobbyTab = 1
    
    @Published var personalGradientBGColor = LinearGradient(gradient: Gradient(colors: [Color("bg_color"), .black]), startPoint: .bottomTrailing, endPoint: .topLeading)
    
    private init() {
        //SINGLETON. PRIVATE INIT.
        loggedInUser = testUser
    }
    
    func logout() {
        
        let currentUserOnline = UserOnlineFirebase(_id: loggedInUser.id, _username: loggedInUser.username, _isOnline: false)
        let firebaseUserOnlineModel = FirestoreUserOnlineModel()
        firebaseUserOnlineModel.updateOnlineUser(currentUserOnline: currentUserOnline)
        coreDataUser = nil
        profileUser = nil
        
        let logoutUser = loggedInUser
        
        loggedInUser = testUser
        appIndex = AppIndex.startView
        print("Logged out user \(logoutUser.username)")
    }
    
}

enum AppIndex : Int {
    
    case startView = 0, welcomeView, lobbyView, friendsView, onlineUsersView, privateChatView
    
}
