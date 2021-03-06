//
//  PrivateChatView.swift
//  LunarLight
//
//  Created by Karol Öman on 2022-04-11.
//

import SwiftUI

struct PrivateChatView: View {
    
    @StateObject var firestorePrivateMsgModel = FirestorePrivateMsgModel()
    
    @StateObject var firestoreUserModel = FirestoreUserModel()
    
    @State var messages = [PrivateMsgFirebase]()
    
    let currentUser: UserFirebase
    let friend: UserFirebase
    
    let userBackground: String
    let friendBackground: String
    
    @State var newMessage = ""
    
    init() {
        let localData = LocalData()
        
        currentUser = AppManager.singletonObject.loggedInUser
        friend = AppManager.singletonObject.privateChatUser ?? AppManager.singletonObject.testUser
        
        let userStoneIndex = LocalData.getStoneIndex(month: currentUser.month, day: currentUser.day)
        let userStoneType = localData.profileBackground[userStoneIndex]
        
        userBackground = userStoneType
        
        let friendStoneIndex = LocalData.getStoneIndex(month: friend.month, day: friend.day)
        let friendStoneType = localData.profileBackground[friendStoneIndex]
        
        friendBackground = friendStoneType
    }
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(userBackground), Color(friendBackground)]), startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            
            VStack{
                Button {
                    firestoreUserModel.getProfileUser(profileId: friend.id)
                } label: {
                    Text(friend.username)
                        .foregroundColor(.white)
                }
                .sheet(isPresented: $firestoreUserModel.profileUserActive){
                    ProfileView()
                }

                
                HStack {
                    Button {
                        AppManager.singletonObject.appIndex = AppIndex.lobbyView
                    } label: {
                        Text("< Back")
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                }
                ScrollViewReader{ proxy in
                    
                ScrollView{
                    
                    Divider()
                        .padding(2)
                        .opacity(0)
                    
                    ForEach (Array(messages.enumerated()), id: \.1) { index, message in
                        //Check if its yours or your friends message (alignment (left or right side) is decided in MessageView-struct file)
                        if message.sender_id == currentUser.id {
                            MessageView(_username: currentUser.username, _message: message.my_message, _avatar: currentUser.avatar, _month: currentUser.month, _day: currentUser.day, _isPrivate: true )
                                .id(index)
                        }
                        else{
                            MessageView(_username: friend.username, _message: message.my_message, _avatar: friend.avatar, _month: friend.month, _day: friend.day, _isPrivate: true )
                                .id(index)
                        }
                    }
                    .onChange(of: messages, perform: { index in
                        SoundPlayer.playSound(sound: SoundPlayer.NEW_MSG_SFX)
                    })
                }
                    
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("gradient_black_20"))
                .cornerRadius(30)
                .padding()
                .onAppear {
                               proxy.scrollTo(messages.count - 1, anchor: .top)
                           }
                .onChange(of: messages.count, perform: { index in
                                proxy.scrollTo(messages.count - 1)
                                
                            })
            }
                HStack {
                    TextField("Enter message..", text: $newMessage)
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .padding()
                    
                    
                    Button {
                        newPrivateMsg()
                    } label: {
                        Text("Send")
                            .padding()
                    }
                    .font(Font.subheadline.weight(.bold))
                    .foregroundColor(Color.white)
                    .padding(2)
                    .background(Color("gradient_black_20"))
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color("gradient_black_20"))
                .cornerRadius(30)
                .padding()
                
            }.background(Image("star_bg_sky")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea())
            .onAppear(perform: {
                firestorePrivateMsgModel.listenToUserMsgs() //listen to msgs that you have sent to your friend
                firestorePrivateMsgModel.listenToFriendMsgs()   //listen to msgs that your friend has sent to you
            })
            .onChange(of: firestorePrivateMsgModel.userMsgs, perform: {newValue in
                updateMessagesArray()
            })
            .onChange(of: firestorePrivateMsgModel.friendMsgs, perform: {newValue in
                updateMessagesArray()
            })
            
        }
    
    }
    
    //combines private messages from you and your friend into one array and sort by timestamp
    func updateMessagesArray() {
        self.messages.removeAll()
        self.messages.append(contentsOf: firestorePrivateMsgModel.userMsgs)
        self.messages.append(contentsOf: firestorePrivateMsgModel.friendMsgs)
        self.messages = self.messages.sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    func newPrivateMsg () {
        
        //return if input field is empty
        if (newMessage.isEmpty) {
            return
        }
        
        let currentUserId = AppManager.singletonObject.loggedInUser.id
        let friendId = friend.id
        
        let newPrivateMsg = PrivateMsgFirebase(_message: newMessage, _senderId: currentUserId, _receiverId: friendId)
        newMessage = "" //clear the input field
        
        firestorePrivateMsgModel.createPrivateMsg(newPrivateMsg: newPrivateMsg, currentUserId: currentUserId, friendId: friendId)
        
    }
    
}

struct PrivateChatView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateChatView()
    }
}
