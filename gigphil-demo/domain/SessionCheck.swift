//
//  UserSession.swift
//  gigphil-demo
//
//  Created by 田代創大 on 2019/10/27.
//  Copyright © 2019 田代創大. All rights reserved.
//

import Foundation

// 現状tokenExpiresAtを無視した設計になっているので、
// 動作全てにフック出来たらtokenExpiresAtを考慮した作りに直す
// 今は起動時のみ必ずsessionを更新するように呼んでいる

class SessionCheck {
    var isUnregistered : Bool = false
    var isLunchEvent : Bool = false
    
    init(){
        if UserDefaults.standard.string(forKey: Const.UserDefaultKeys.tokenExpiresAt) == nil {
             isUnregistered = true
        }
    }
    
    func execute() {
        if(isUnregistered){
            registUser()
        } else {
           updateSession()
        }
    }
    
    private func updateSession() {
        let path = "/session"
        guard let req_url = URL(
                string: Const.API.host + path + "?refresh_token=" + UserDefaults.standard.string(forKey: Const.UserDefaultKeys.refreshToken)!
            ) else { return }
        var request = URLRequest(url: req_url)
        request.httpMethod = "PUT"
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: {
               (data , response , error) in
               session.finishTasksAndInvalidate()
               do {
                    let json = try JSONSerialization.jsonObject(with: data!)
                    let user = try User.decodeValue(json, rootKeyPath: ["data", "attributes"])
                    UserDefaults.standard.set(user.token_expires_at, forKey: Const.UserDefaultKeys.tokenExpiresAt)
                    UserDefaults.standard.set(user.access_token, forKey: Const.UserDefaultKeys.accessToken)
               } catch {
                    print(error)
               }
        })
        task.resume()
    }
    
    private func registUser() {
        let path = "/user"
        guard let req_url = URL(string: Const.API.host + path) else { return }
        var request = URLRequest(url: req_url)
        request.httpMethod = "POST"
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: {
               (data , response , error) in
               session.finishTasksAndInvalidate()
               do {
                    let json = try JSONSerialization.jsonObject(with: data!)
                    let user = try User.decodeValue(json, rootKeyPath: ["data", "attributes"])
                    UserDefaults.standard.set(user.token_expires_at, forKey: Const.UserDefaultKeys.tokenExpiresAt)
                    UserDefaults.standard.set(user.access_token, forKey: Const.UserDefaultKeys.accessToken)
                    UserDefaults.standard.set(user.refresh_token, forKey: Const.UserDefaultKeys.refreshToken)
               } catch {
                    print(error)
               }
        })
        task.resume()
    }
}
