//
//  WalletEntity.swift
//  Money Keeper
//
//  Created by andromeda on 11/28/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import Foundation

class WalletEntity{
    static let shared = WalletEntity()
    
    private let CREATETABLE = """
                  CREATE TABLE WALLET(
                  ID INT PRIMARY KEY,
                  NAME VARCHAR(250) NOT NULL,
                  IDICON INT NOT NULL,
                  BALANCE DOUBLE NOT NULL,
                  FOREIGN KEY (IDICON) REFERENCES ICON(ID),
                  )
                  """
    
    private init(){
        do {
            try Database.shared.connection?.CreateTable(SQL: self.CREATETABLE, Complete: nil)
        }catch let er{
            print(er)
        }
    }
    
    private func defaultInsert(){
        do{
            try insert(ID: 1, NAME: "Cash wallet", IDICON: 45)
        }catch{
            print("WALLET: Fail inserted row.")
        }
    }
    
    func insert(ID: Int, NAME: String, IDICON: Int, BALANCE: Double = 0) throws{
        let SQL = """
                  INSERT INTO WALLET (ID, NAME, IDICON, BALANCE)
                  VALUES (?, ?, ?, ?)
                  """
        let name = NAME as NSString
        let insertStatement = try Database.shared.connection?.prepareStatement(SQL: SQL)
        defer{
            sqlite3_finalize(insertStatement)
        }
        
        guard sqlite3_bind_int(insertStatement, 1, Int32(ID)) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_int(insertStatement, 3, Int32(IDICON)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 4, BALANCE) == SQLITE_OK
            else{
                throw SQLiteError.Bind(message: Database.shared.connection!.errorMessage)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else{
            throw SQLiteError.Step(message: Database.shared.connection!.errorMessage)
        }
        print("WALLET: Successfully inserted row.")
    }
    
    func count() -> Int{
        do {
            let count = try Database.shared.connection?.count("WALLET", nil)
            return count ?? 0
        }catch let er{
            print(er)
            return 0
        }
    }
    
    func remove(id: Int) -> Bool{
        do{
            try Database.shared.connection?.remove("WALLET", id: id)
            return true
        }catch let er{
            print(er)
            return false
        }
    }
}
