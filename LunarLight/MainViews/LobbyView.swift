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
            
            WorldChatView()
            .tabItem{
                    Image(systemName: "house")
                    Text("World Chat")
                }
            
            LobbyChatView()
                .tabItem{
                    Image(systemName: "bubble.left.fill")
                    Text("Friends")
                }
            
            ProfileView(_user: AppIndexManager.singletonObject.currentUser)
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
