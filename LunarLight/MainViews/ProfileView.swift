//
//  ProfileView.swift
//  LunarLight
//
//  Created by Sarah Lidberg on 2022-04-05.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var showingSheet = false
    @State var index = 0
    
    @State var user: UserFirebase
    let readOnly: Bool
    var stone: String
    let bGColorOfPressedUser: String
    
    @State var infoText = ["profileInfo",
                           "stoneInfo"]
    
    init(_user: UserFirebase){
        let localData = LocalData()
        
        user = _user
        readOnly = AppIndexManager.singletonObject.loggedInUser.id == _user.id ? false : true
        
        let stoneIndex = UserFirebase.getStoneIndex(month: _user.month, day: _user.day)
        
        bGColorOfPressedUser = localData.profileBackground[stoneIndex]
  
        stone = localData.stoneArray[stoneIndex]
        
        print("Detta är user: \(_user)")
        
    }
    
    var body: some View {
        

            VStack{
                
                if readOnly {
                    Button {
                        addFriend()
                    } label: {
                        Text("Add friend")
                            .foregroundColor(.white)
                    }
                }
                
                //knappen för settings sheet
                HStack{
                    
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                        
                    }.sheet(isPresented: $showingSheet){
                        SheetView()
                    }
                    
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(5)
                    .opacity(readOnly ? 0 : 1)
                    .disabled(readOnly ? true : false)
                    
                }
                .padding()
                
                //Namn och profilbild
                Image(user.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Text(user.username)
                    .font(.title).bold()
                    .padding()
                    .foregroundColor(.white)
                
                //tab view items
                HStack{
                    Spacer()
                    
                    Button(action: {
                        
                        self.index = 0
                    }) {
                        
                        Text("About me")
                            .foregroundColor(self.index == 0 ? Color.white : .white.opacity(0.5))
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(self.index == 0 ? Color.black.opacity(0.5) : Color.clear)
                            .cornerRadius(10)
                            .onAppear {
                                infoText[0] = user.profile_info
                            }
                        
                    }
                    Spacer()
                    Button(action: {
                        
                        self.index = 1
                        
                    }) {
                        
                        Text(stone)
                            .foregroundColor(self.index == 1 ? Color.white : .white.opacity(0.5))
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(self.index == 1 ? Color.black.opacity(0.5) : Color.clear)
                            .cornerRadius(10)
                            .onAppear {
                                let localData = LocalData()
                                print(stone)
                                infoText[1] = localData.stonesInfo[stone] ?? "Could not find stone info."
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal,10)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.2))
//                .shadow(color: Color(backgroundColor).opacity(0.5), radius: 5, x: -5, y: -5)
                
                
                //FIXA HÄR MED V-STACK och SCROLL VIEW. så save knappen hoppar ner.
                ScrollView{
                    
                    
                    if index == 0 {
                        if readOnly {
                            Text(infoText[0])
                        }
                        else {
                            TextField(user.profile_info, text: $infoText[0])
                                .background(Color("gradient_white_10"))
                                .foregroundColor(.white)
                            
                            Spacer ()
                            
                            Button {
                                updateInfoTextUser()
                                
                                
                            } label: {
                                Text("Save")
                            }
                            .padding()
                            .background(Color("gradient_white_10"))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            
                        }
                        
                    }else{
                        Text(infoText[1])
                            .padding()
                            .background(Color("gradient_white_10"))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding()
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("star_bg_sky")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea())
        
            .background(
                user.id == AppIndexManager.singletonObject.loggedInUser.id ? AppIndexManager.singletonObject.personalGradientBGColor : LinearGradient(gradient: Gradient(colors: [Color(bGColorOfPressedUser), .black]),startPoint: .bottomTrailing, endPoint: .topLeading))
            .onAppear {
            if user.id == AppIndexManager.singletonObject.loggedInUser.id {
                infoText[0] = AppIndexManager.singletonObject.loggedInUser.profile_info
                
            }
        }
    }
    
    private func addFriend() {
        
        let friendId = user.id
        
        let newFriend = FriendFirebase(_userId: friendId)
        
        let firestoreFriendModel = FirestoreFriendModel()
        
        firestoreFriendModel.createFriend(newFriend: newFriend)
        
    }
    
    private func updateInfoTextUser(){
        
        user.profile_info = infoText[0]
        
        AppIndexManager.singletonObject.loggedInUser.profile_info = infoText[0]
        let firestoreUserModel = FirestoreUserModel()
        firestoreUserModel.updateUser(currentUser: AppIndexManager.singletonObject.loggedInUser)
        
        AppIndexManager.singletonObject.coreDataUser?.profile_info = infoText[0]
        let coreDataUserModel = CoredataUserModel()
        coreDataUserModel.updateUser()
        
        
    }
    
}

struct SheetView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var resetPassword: String = ""
    
    var body: some View {
        
        
        Button {
            print("dismiss")
            dismiss()
        } label: {
            Text("dismiss")
                .foregroundColor(.white)
                .font(.title)
                .padding()
                .background(Color.black)
        }
        
        VStack{
            
            HStack{
                Text("Reset password")
                TextField("Reset password", text: $resetPassword)
            }
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(_user: AppIndexManager.singletonObject.testUser)
    }
}
