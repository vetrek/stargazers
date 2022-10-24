//
//  Star.swift
//  Stargazers
//
//  Created by Valerio Sebastianelli on 21/10/22.
//

import Foundation

struct Stargazer: Hashable {
    let user: GithubUser
    let starredAt: Date?
}
