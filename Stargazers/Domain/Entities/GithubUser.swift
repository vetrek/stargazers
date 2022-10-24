//
//  GithubUser.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation

struct GithubUser: Hashable {
    let id: Int
    let userName: String
    let avatarURL: URL?
}
