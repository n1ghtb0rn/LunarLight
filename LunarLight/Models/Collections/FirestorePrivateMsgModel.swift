//
//  FirestorePrivateMsgModel.swift
//  LunarLight
//
//  Created by Hampus Brandtman on 2022-04-08.
//

import Foundation
import Firebase

class FirestorePrivateMsgModel: ObservableObject {
    
    let dataBase = Firestore.firestore()
    
    @Published var userMsgs = [PrivateMsgFirebase]()
    @Published var friendMsgs = [PrivateMsgFirebase]()

    func createPrivateMsg(newPrivateMsg: PrivateMsgFirebase, currentUserId: String, friendId: String) {
        
        do {
            _ = try dataBase
                .collection(LocalData.USERS_COLLECTION_KEY).document(currentUserId)
                .collection(LocalData.FRIENDS_COLLECTION_KEY).document(friendId)
                .collection(LocalData.PRIVATE_MESSAGES_COLLECTION_KEY).document(newPrivateMsg.id)
                .setData(from: newPrivateMsg)
        } catch {
            print("Error: Could not save Private Message to Firebase")
        }
        
    }
    
    func listenToUserMsgs() {
        
        //Read data once (example):
        //db.collection("tmp").getDocuments(completion: )
        
        guard let friendId = AppManager.singletonObject.privateChatUser?.id else { return }
        
        let userId = AppManager.singletonObject.loggedInUser.id
        
        //Add an async listener for database
        dataBase.collection(LocalData.USERS_COLLECTION_KEY).document(userId)
            .collection(LocalData.FRIENDS_COLLECTION_KEY).document(friendId)
            .collection(LocalData.PRIVATE_MESSAGES_COLLECTION_KEY)
            .order(by: LocalData.TIMESTAMP_DOCUMENT_KEY, descending: false)
            .addSnapshotListener { snapshot, error in
                
            //print("Something was changed in database")
            guard let snapshot = snapshot else { return }
            
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            self.userMsgs.removeAll()
            
            for document in snapshot.documents {
                
                let result = Result {
                    try document.data(as: PrivateMsgFirebase.self)
                }
                
                switch result {
                case .success(let item):
                    self.userMsgs.append(item)
                case .failure(let error):
                    print("User decode error: \(error)")
                }
            }
        }
    }
    
    func listenToFriendMsgs() {
        
        //Read data once (example):
        //db.collection("tmp").getDocuments(completion: )
        
        guard let friendId = AppManager.singletonObject.privateChatUser?.id else { return }
        
        let userId = AppManager.singletonObject.loggedInUser.id
        
        //Add an async listener for database
        dataBase.collection(LocalData.USERS_COLLECTION_KEY).document(friendId)
            .collection(LocalData.FRIENDS_COLLECTION_KEY).document(userId)
            .collection(LocalData.PRIVATE_MESSAGES_COLLECTION_KEY)
            .order(by: LocalData.TIMESTAMP_DOCUMENT_KEY, descending: false)
            .addSnapshotListener { snapshot, error in
                
            //print("Something was changed in database")
            guard let snapshot = snapshot else { return }
            
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            self.friendMsgs.removeAll()
            
            for document in snapshot.documents {
                
                let result = Result {
                    try document.data(as: PrivateMsgFirebase.self)
                }
                
                switch result {
                case .success(let item):
                    self.friendMsgs.append(item)
                case .failure(let error):
                    print("User decode error: \(error)")
                }
            }
        }
    }
    
}
