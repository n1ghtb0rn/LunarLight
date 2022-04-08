//
//  WorldChatView.swift
//  LunarLight
//
//  Created by Daniel Falkedal on 2022-04-07.
//

import SwiftUI

struct WorldChatView: View {
    
    @StateObject private var firestoreWorldMsgModel = FirestoreWorldMsgModel()
    
    @State private var messageInput: String = ""
    
    var body: some View {
        VStack{
            Text("Lobby View")
            Button {
                AppIndexManager.singletonObject.appIndex = AppIndex.onlineUsersView
            } label: {
                Text("Show Online Users")
            }.padding()
            
            ScrollView{
                
                ForEach(firestoreWorldMsgModel.worldMessages) { worldMsg in
                    MessageView(_user: worldMsg.username, _message: worldMsg.message, _avatar: worldMsg.avatar, _month: worldMsg.month, _day: worldMsg.day )
                        .onAppear(perform: { print(worldMsg.message) })
                }
                .onChange(of: firestoreWorldMsgModel.worldMessages, perform: { newValue in
                    print("*BLIPP*")
                    SoundPlayer.playSound(sound: SoundPlayer.NEW_MSG_SFX)
                })

                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("gradient_black_20"))
            .cornerRadius(30)
            .padding()
            
            HStack {
                TextField("Say something to the world...", text: $messageInput)
                    .padding()
                Button {
                    sendMessage()
                } label: {
                    Text("Send")
                        .padding()
                }
                .background(Color("gradient_black_40"))
                .cornerRadius(30)

            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color("gradient_black_20"))
            .cornerRadius(30)
            .padding([.leading, .bottom, .trailing], 20)

        }
        .onAppear(perform: {
            firestoreWorldMsgModel.listenToWorldMessages()
        })
    }
    
    private func sendMessage() {
        if messageInput.isEmpty {
            return
        }
        
        print(messageInput)
        
        let currentUser = AppIndexManager.singletonObject.currentUser
        let newMessage = WorldMsgFirebase(_userId: currentUser.id, _username: currentUser.username, _message: messageInput, _avatar: currentUser.avatar, _month: currentUser.month, _day: currentUser.day)
        
        firestoreWorldMsgModel.createMessage(newMessage: newMessage)
        
        messageInput = ""
    }
}

struct WorldChatView_Previews: PreviewProvider {
    static var previews: some View {
        WorldChatView()
    }
}
