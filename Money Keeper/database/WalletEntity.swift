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
                  CREATE TABLE WALLET (
                  ID INT PRIMARY KEY,
                  NAME VARCHAR(255) NOT NULL,
                  IDICON INT NOT NULL,
                  BALANCE DOUBLE NOT NULL,
                  FOREIGN KEY (IDICON) REFERENCES ICON(ID)
                  )
                  """
    
    private init(){
        do {
            try Database.shared.connection?.CreateTable(SQL: self.CREATETABLE, Complete: self.defaultInsert)
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
    
    func getWallet(ID: Int, _ WHERE: String? = nil)->Wallet?{
        var SQL = """
                  SELECT *
                  FROM WALLET
                  WHERE ID = ?
                  """
        
        if let wh = WHERE{
            SQL.append(" AND \(wh)")
        }
        
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                print("WALLET: get prepare statement fail.")
                return nil
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_bind_int(queryStatement, 1, Int32(ID)) == SQLITE_OK
            else{
                print("WALLET: bind statement fail.")
                return nil
        }
        
        if sqlite3_step(queryStatement) == SQLITE_ROW{
            let wallet = Wallet()
            wallet.id = Int(sqlite3_column_int(queryStatement, 0))
            let queryTemp = sqlite3_column_text(queryStatement, 1)
            wallet.name = String(cString: queryTemp!)
            wallet.idIcon = Int(sqlite3_column_int(queryStatement, 2))
            wallet.balance = sqlite3_column_double(queryStatement, 3)
            
            return wallet
        }
        return nil
    }
    
    func getWallets()->[Wallet]{
        var SQL = """
                  SELECT *
                  FROM WALLET
                  """
        var wallets = [Wallet]()
        
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                print("WALLET: get prepare statement fail.")
                return wallets
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        while sqlite3_step(queryStatement) == SQLITE_ROW{
            let wallet = Wallet()
            wallet.id = Int(sqlite3_column_int(queryStatement, 0))
            let queryTemp = sqlite3_column_text(queryStatement, 1)
            wallet.name = String(cString: queryTemp!)
            wallet.idIcon = Int(sqlite3_column_int(queryStatement, 2))
            wallet.balance = sqlite3_column_double(queryStatement, 3)
            wallets.append(wallet)
        }
        return wallets
    }
}

class Wallet{
    var id:Int
    var name: String
    var idIcon: Int
    var balance: Double
    init() {
        id = Int(0)
        name = String()
        idIcon = Int(0)
        balance = Double(0)
    }
}
