//
//  History.swift
//  Money Keeper
//
//  Created by andromeda on 11/28/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

//dateformatter: dd mm yyyy

import Foundation

class HistoryEntity{
    static let shared = HistoryEntity()
    
    let dateFormatter = DateFormatter()
    
    private let CREATETABLE = """
                  CREATE TABLE HISTORY(
                  ID INTEGER PRIMARY KEY AUTOINCREMENT,
                  TIME VARCHAR(50) NOT NULL,
                  NOTE VARCHAR(500),
                  IDCATEGORY INT NOT NULL,
                  MONEY REAL NOT NULL,
                  IDWALLET INT NOT NULL,
                  FOREIGN KEY (IDCATEGORY) REFERENCES CATEGORY(ID),
                  FOREIGN KEY (IDWALLET) REFERENCES WALLET(ID)
                  )
                  """
    
    private init(){
        dateFormatter.dateFormat = "dd MM yyyy"
        do{
            try Database.shared.connection?.CreateTable(SQL: self.CREATETABLE, Complete: nil)
        }catch let er{
            print(er)
        }
    }
    
    func insert(timeFormat TIME: String, NOTE: String, IDCATEGORY: Int, MONEY: Double, IDWALLET: Int) throws{
        
        let SQL = """
            INSERT INTO HISTORY (TIME, NOTE, IDCATEGORY, MONEY, IDWALLET)
            VALUES (?, ?, ?, ?, ?)
            """
        
        let insertStatement = try Database.shared.connection?.prepareStatement(SQL: SQL)
        defer{
            sqlite3_finalize(insertStatement)
        }
        
        let not = NOTE as NSString
        let time = TIME as NSString
        
        guard sqlite3_bind_text(insertStatement, 1, time.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, not.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_int(insertStatement, 3, Int32(IDCATEGORY)) == SQLITE_OK && sqlite3_bind_double(insertStatement, 4, MONEY) == SQLITE_OK && sqlite3_bind_int(insertStatement, 5, Int32(IDWALLET)) == SQLITE_OK else{
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
    
    private func DateConditionDefault(_ time1: Date, _ time2: Date)->Bool{
        let strT1 = dateFormatter.string(from: time1)
        let strT2 = dateFormatter.string(from: time2)
        return strT1 == strT2
    }
    
    func getMoneyOfDate(kind: Kind, Time: Date, _ condition: ((Date, Date)->Bool)? = nil)-> Double{
        let histories = getHistory(kind)
        var result:Double = 0
        
        let condition = condition ?? DateConditionDefault
            
        for history in histories{
            let date = dateFormatter.date(from: history.time)!
            if condition(Time, date){
                result += history.money
            }
        }
        
        return result
    }
    
    func getBalanceOfDate(Time: Date, _ condition: ((Date, Date)->Bool)? = nil)-> Double{
        let income = getMoneyOfDate(kind: .income, Time: Time, condition)
        let expense = getMoneyOfDate(kind: .expense, Time: Time, condition)
        return income - expense
    }
    
    func getHistory(_ KIND: Kind? = nil)->[History]{
        var result = [History]()
        var SQL: String
        
        if let KIND = KIND{
            SQL = """
                  SELECT H.*
                  FROM HISTORY H JOIN CATEGORY C ON H.IDCATEGORY = C.ID
                  WHERE C.KIND = \(KIND.rawValue)
                  """
        }else{
            SQL = """
            SELECT *
            FROM HISTORY
            """
        }
        
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                print("HISTORY: get prepare statement fail.")
                return result
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        while sqlite3_step(queryStatement) == SQLITE_ROW{
            let history = History()
            history.id = Int(sqlite3_column_int(queryStatement, 0))
            let noteTime = sqlite3_column_text(queryStatement, 1)
            history.time = String(cString: noteTime!)
            let noteTemp = sqlite3_column_text(queryStatement, 2)
            history.note = String(cString: noteTemp!)
            history.idCategory = Int(sqlite3_column_int(queryStatement, 3))
            history.money = sqlite3_column_double(queryStatement, 4)
            history.idWallet = Int(sqlite3_column_int(queryStatement, 5))
            result.append(history)
        }
        return result
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
            let noteTime = sqlite3_column_text(queryStatement, 1)
            history.time = String(cString: noteTime!)
            let noteTemp = sqlite3_column_text(queryStatement, 2)
            history.note = String(cString: noteTemp!)
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
    var time:String
    var idCategory:Int
    var note:String?
    var money:Double
    var idWallet:Int
    
    init() {
        id = Int()
        time = String()
        idCategory = Int()
        money = Double()
        idWallet = Int()
    }
}
