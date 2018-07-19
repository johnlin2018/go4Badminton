//
//  Message.swift
//  App
//
//  Created by john lin on 7/18/18.
//

import Foundation

import Vapor
import FluentSQLite


struct Message: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var username: String
    var content: String
    var date: Date
}
