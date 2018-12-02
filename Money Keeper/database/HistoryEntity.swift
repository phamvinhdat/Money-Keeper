//
//  History.swift
//  Money Keeper
//
//  Created by andromeda on 11/28/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import Foundation

class HistoryEntity{
    static let shared = HistoryEntity()
    
    private let CREATETABLE = """
                  CREATE TABLE HISTORY(
                  ID INT PRIMARY KEY AUTOINCREMENT,
                  TIME INT,
                  NOTE VARCHAR(500),
                  IDCATEGORY INT NOT NULL,
                  MONEY DOUBLE NOT NULL,
                  IDWALLET INT NOT NULL,
                  FOREIGN KEY (IDCATEGORY) REFERENCES CATEGORY(ID),
                  FOREIGN KEY (IDWALLET) REFERENCES WALLET(ID)
                  )
                  """
    
    private init(){
        do{
            try Database.shared.connection?.CreateTable(SQL: self.CREATETABLE, Complete: nil)
        }catch let er{
            print(er)
        }
    }
    
    func insert(timeIntervalSince1970 TIME: Int, NOTE: String, IDCATEGORY: Int, MONEY: Double, IDWALLET: Int) throws{
        
        let SQL = """
            INSERT INTO HISTORY (TIME, NOTE, IDCATEGORY, MONEY, IDWALLET)
            VALUES (?, ?, ?, ?, ?)
            """
        
        let insertStatement = try Database.shared.connection?.prepareStatement(SQL: SQL)
        defer{
            sqlite3_finalize(insertStatement)
        }
        
        let not = NOTE as NSString
        
        guard sqlite3_bind_int(insertStatement, 1, Int32(TIME)) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, not.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_int(insertStatement, 3, Int32(IDCATEGORY)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 4, MONEY) == SQLITE_OK && sqlite3_bind_int(insertStatement, 5, Int32(IDWALLET)) == SQLITE_OK else{
                    throw SQLiteError.Bind(message: "HISTORY: Bind error")
            }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else{
            throw SQLiteError.Step(message: "HISTORY: Insert step error")
        }
        print("HISTORY: Successfully inserted row.")
    }
    
    func count() -> Int{
        do{
            let count = try Database.shared.connection?.count("HISTORY", nil)
            return count ?? 0
        }catch let er{
            print(er)
            return 0
        }
    }
    func remove(id: Int) -> Bool{
        do{
            try Database.shared.connection?.remove("HISTORY", id: id)
            return true
        }catch let er{
            print(er)
            return false
        }
    }
    
    func getHistory(ID: Int, _ WHERE: String? = nil)->History?{
        var SQL = """
                  SELECT *
                  FROM HISTORY
                  WHERE ID = ?
                  """
        
        if let wh = WHERE{
            SQL.append(" AND \(wh)")
        }
        
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                print("HISTORY: get prepare statement fail.")
                return nil
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_bind_int(queryStatement, 1, Int32(ID)) == SQLITE_OK
            else{
                print("HISTORY: bind statement fail.")
                return nil
        }
        
        if sqlite3_step(queryStatement) == SQLITE_ROW{
            let history = History()
            history.id = Int(sqlite3_column_int(queryStatement, 0))
            history.time = Int(sqlite3_column_int(queryStatement, 1))
            let queryTemp = sqlite3_column_text(queryStatement, 2)
            history.note = String(cString: queryTemp!)
            history.idCategory = Int(sqlite3_column_int(queryStatement, 3))
            history.money = sqlite3_column_double(queryStatement, 4)
            history.idWallet = Int(sqlite3_column_int(queryStatement, 5))
            
            return history
        }
        return nil
    }
}

class History{
    var id:Int
    var time:Int
    var idCategory:Int
    var note:String?
    var money:Double
    var idWallet:Int
    
    init() {
        id = Int()
        time = Int()
        idCategory = Int()
        money = Double()
        idWallet = Int()
    }
}
