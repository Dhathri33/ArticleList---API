//
//  User.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 10/1/25.
//
enum UDKeys {
    static let username = "loggedInUsername"
}

struct User {
    var username: String
    var password: String
    
    static func sampleData() -> [User] {
        return [
            User(username: "Dhathri", password: "Dhathri"),
            User(username: "Aditi", password: "Aditi"),
            User(username: "Sathvika", password: "Sathvika"),
            User(username: "Koushik", password: "Koushik"),
            User(username: "Tejasv", password: "Tejasv")
        ]
    }
}
