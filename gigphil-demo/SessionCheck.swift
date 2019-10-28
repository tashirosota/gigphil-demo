//
//  UserSession.swift
//  gigphil-demo
//
//  Created by 田代創大 on 2019/10/27.
//  Copyright © 2019 田代創大. All rights reserved.
//

import Foundation
import Himotoki

class SessionCheck {
    var isUnregistered : Bool = false
    var isExpired : Bool = false
    
    init(){
        if let expiresAt = UserDefaults.standard.string(forKey: Const.UserDefaultKeys.tokenExpiresAt) {
            //すでに登録済みの場合は期限が切れていないかどうかを確認する
            let currntDateTime = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ'"
            let expiresDateTime = dateFormatter.date(from: expiresAt)
            if currntDateTime.compare(expiresDateTime!) == .orderedDescending { isExpired = true }
        } else {
             isUnregistered = true
        }
    }
    
    func execute() {
        if(isUnregistered){
            registUser()
        } else {
            if(isExpired){ updateSession() }
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
                    let user = try User.decodeValue(json)
                    print(user)
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
                    let user = try User.decodeValue(json)
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

// decodeする必要あるん？
struct User : Himotoki.Decodable{
    var token_expires_at: String
    var access_token: String?
    var refresh_token: String?
    static func decode(_ e: Extractor) throws -> User {
        return try User(
            token_expires_at: e <| ["data", "attributes","token_expires_at"],
            access_token: e <| ["data", "attributes","access_token"],
            refresh_token: e <|? ["data", "attributes","refresh_token"]
        )
    }
}
