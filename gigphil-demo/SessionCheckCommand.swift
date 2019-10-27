//
//  UserSession.swift
//  gigphil-demo
//
//  Created by 田代創大 on 2019/10/27.
//  Copyright © 2019 田代創大. All rights reserved.
//

import Foundation

class SessionCheckCommand {
    var isUnegistered : Bool
    var isExpired : Bool
    
    init(){
        if UserDefaults.standard.bool(forKey: Const.UserDefaultKeys.tokenExpiresAt) {
            isExpired = true
        } else {
            isUnegistered = true
        }
    }
    
    func execute() {
        if(isUnegistered){
            if(isExpired){ updateSession() }
        } else {
            registerUser()
        }
    }
    
    private func updateSession() {
        
    }
    
    private func registerUser() {
        
    }
}
