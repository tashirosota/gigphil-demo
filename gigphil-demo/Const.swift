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
      static let resetToken = "resetToken"
      static let refershToken = "refershToken"
      static let tokenExpiresAt = "tokenExpiresAt"
    }
    
    // API
    struct API {
        static let domain = "gigphil.herokuapp.com"
        static let host = "https://\(domain)/api"
    }
}
