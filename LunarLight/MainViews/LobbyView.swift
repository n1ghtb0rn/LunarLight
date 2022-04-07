//
//  LobbyView.swift
//  LunarLight
//
//  Created by Sarah Lidberg on 2022-04-01.
//

import SwiftUI

struct LobbyView: View {
    
    var body: some View {
        
        
        
        TabView {
            
            
            VStack{
                Text("Lobby View")
                Button {
                    AppIndexManager.singletonObject.appIndex = AppIndex.onlineUsersView
                } label: {
                    Text("Online")
                }

            }
            .tabItem{
                    Image(systemName: "house")
                    Text("Chat")
                }
            
            LobbyChatView()
                .tabItem{
                    Image(systemName: "bubble.left.fill")
                    Text("Lobby chat")
                }
            
            ProfileView()
                .tabItem{
                    Image(systemName: "gearshape.fill")
                    Text("Profile")
                    
                }
        }
        .font(.headline)
    }

}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView( )
    }
}
