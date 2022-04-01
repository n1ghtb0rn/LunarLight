//
//  SecurePassword.swift
//  LunarLight
//
//  Created by Sarah Lidberg on 2022-03-31.
//

import SwiftUI

struct RegisterView: View {
    
    private let inputValidator = InputValidator()
    
    @State private var password: String = ""
    @State private var passwordTwo: String = ""
    @State private var secured: Bool = true
    
    @State private var email: String = ""
    @State private var passwordCheck: String = ""
    @State private var username: String = ""
    
    var body: some View {
        
        VStack{
            
            TextField("username", text: $username)
            
            TextField("Email", text: $email)
            
            HStack{
                
                if secured {
                    
                    
                    SecureField("Password", text: $password)
                        .padding(4)
                        .border(Color.black, width: 1)
                        .id(1)
                } else {
                    
                    // 3
                    TextField("Password", text: $password)
                        .padding(4)
                        .border(Color.black, width: 1)
                }
                
                Button(action: {
                    self.secured.toggle()
                }) {
                    
                    
                    if secured {
                        Image(systemName: "eye.slash")
                    } else {
                        Image(systemName: "eye")
                    }
                }
            }
            
            SecureField("Reenter password", text: $passwordTwo)
                .padding(4)
                .border(Color.black, width: 1)
                .id(2)
                        
            Button {
                
                if processRegister() {
                    AppIndexManager.singletonObject.appIndex = AppIndex.registerQuestionsView
                }
                
            } label: {
                Text("Register")
            }
            
        }
        
    }
    
    private func processRegister() -> Bool {
        
        if password != passwordTwo {
            print("Password not the same buga buga")
            return false
        }
        
        if !inputValidator.isValidEmail(email) {
            print("Email wrong format")
            return false
        }
        
        print("register")
        return true
        
    }
    
}

struct SecurePassword_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}