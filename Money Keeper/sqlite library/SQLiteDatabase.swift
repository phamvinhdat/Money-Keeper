//
//  SQLiteDatabase.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/11/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabase{
    fileprivate let dbPointer: OpaquePointer?
    
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    fileprivate var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    //open database if not exists then create database
    static func open(path: String)throws ->SQLiteDatabase{
        var db:OpaquePointer? = nil
        if sqlite3_open(path, &db) == SQLITE_OK{
            return SQLiteDatabase(dbPointer: db)
        }else{
            defer{
                if db != nil{
                    sqlite3_close(db)
                }
            }
            
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String.init(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    func prepareStatement(SQL: String)throws ->OpaquePointer?{
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(dbPointer, SQL, -1, &statement, nil) == SQLITE_OK else{
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
    
    
}

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}
