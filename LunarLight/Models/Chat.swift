//
//  Chat.swift
//  LunarLight
//
//  Created by Sarah Lidberg on 2022-04-01.
//

import Foundation


class Chat: ObservableObject {
    
    
    @Published var entries = [ChatEntry]()
    
    init(){
        
        addMockData()
    }
    
    
    
    func updateEntry(entry: ChatEntry, with content: String?){
        
        if let index = entries.firstIndex(of: entry) {
            if let content = content {
                entries[index].content = content
            }
            
        }
    }
    
    
    
    
    
    func addMockData() {
        
        entries.append(ChatEntry(content: "dag 1"))
        entries.append(ChatEntry(content: "åt mat"))
        entries.append(ChatEntry(content: "sov dåligt"))
        entries.append(ChatEntry(content: "passade barn"))
        entries.append(ChatEntry(content: "gjorde en shoppinglista"))
        
    }
    
}