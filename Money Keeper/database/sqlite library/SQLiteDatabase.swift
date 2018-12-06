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
    
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    //open database if not exists then create database
    static func open(path: String) throws ->SQLiteDatabase{
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
    
    func CreateTable(SQL: String, Complete: (()->Void)?) throws{
        do{
            let statement = try prepareStatement(SQL: SQL)
            guard sqlite3_step(statement) == SQLITE_DONE
                else{
                    throw SQLiteError.Step(message: errorMessage)
            }
            //run complete
            if let run = Complete{
                run()
            }
            print("\(SQL): table created.")
        }catch{
            throw SQLiteError.Prepare(message: errorMessage)
        }
    }
    
    func count(_ tableName: String, _ WHERE: String?) throws -> Int{
        var SQL = """
                  SELECT COUNT()
                  FROM \(tableName)
                  """
        
        if let wh = WHERE{
            SQL.append("\nWHERE \(wh)")
        }
        
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL) else{
            throw SQLiteError.Prepare(message: errorMessage)
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_ROW else{
            throw SQLiteError.Step(message: errorMessage)
        }
        
        return Int(sqlite3_column_int(queryStatement, 0))
    }
    
    func remove(_ tableName: String, id: Int) throws{
        let SQL = """
                  DELETE FROM \(tableName)
                  WHERE ID = ?
                  """
        guard let removeStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                throw SQLiteError.Prepare(message: errorMessage)
        }
        defer{
            sqlite3_finalize(removeStatement)
        }
        
        guard sqlite3_bind_int(removeStatement, 1, Int32(id)) == SQLITE_OK else{
                throw SQLiteError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(removeStatement) == SQLITE_DONE else{
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(tableName): remove successfully.")
    }
    
    func update(SQL: String) -> Bool{
        guard let updateStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL) else{
            print(Database.shared.connection!.errorMessage)
            return false
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        guard sqlite3_step(updateStatement) == SQLITE_ROW
            else{
                print(Database.shared.connection!.errorMessage)
                return false
        }
        
        return true
    }
}

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}
