//
//  Const.swift
//  gigphil-demo
//
//  Created by 田代創大 on 2019/10/27.
//  Copyright © 2019 田代創大. All rights reserved.
//

import Foundation
// アプリの各種定数を入れておく所
enum Const {
    // UserDefault
    enum UserDefaultKeys {
      static let accessToken = "accessToken"
      static let refreshToken = "refreshToken"
      static let tokenExpiresAt = "tokenExpiresAt"
    }
    
    // API
    struct API {
        static let domain : String = "gigphil.herokuapp.com"
        static let host : String = "https://\(domain)/api"
    }
}
