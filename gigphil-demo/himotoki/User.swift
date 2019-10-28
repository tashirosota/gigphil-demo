//
//  UserSession.swift
//  gigphil-demo
//
//  Created by 田代創大 on 2019/10/27.
//  Copyright © 2019 田代創大. All rights reserved.
//
import Himotoki

struct User : Himotoki.Decodable{
    var token_expires_at: String
    var access_token: String?
    var refresh_token: String?
    static func decode(_ e: Extractor) throws -> User {
        return try User(
            token_expires_at: e <| ["token_expires_at"],
            access_token: e <| ["access_token"],
            refresh_token: e <|? ["refresh_token"]
        )
    }
}
