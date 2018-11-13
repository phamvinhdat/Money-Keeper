//
//  Icon.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/11/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import Foundation

class IconEntity{
    static let shared = IconEntity()

    private init(){
        let SQL = """
                  CREATE TABLE ICON (
                  ID INT PRIMARY KEY,
                  NAME VARCHAR(255) NOT NULL
                  )
                  """
        
        do{
            let statement = try Database.shared.connection?.prepareStatement(SQL: SQL)
            guard sqlite3_step(statement) == SQLITE_DONE
                else{
                    print("ICON: Create table step error.")
                return
            }
            print("ICON table created.")
            //insert value
            try insert(ID: 1, NAME: "icons8-school_building")
            try insert(ID: 2, NAME: "acoustic-guitar")
            try insert(ID: 3, NAME: "alarm-clock")
            try insert(ID: 4, NAME: "bank")
            try insert(ID: 5, NAME: "beach")
            try insert(ID: 6, NAME: "bed")
            try insert(ID: 7, NAME: "bikini")
            try insert(ID: 8, NAME: "buses")
            try insert(ID: 9, NAME: "cafe")
            try insert(ID: 10, NAME: "car-wash")
            try insert(ID: 11, NAME: "chalkboard")
            try insert(ID: 12, NAME: "classroom")
            try insert(ID: 13, NAME: "cycle")
            try insert(ID: 14, NAME: "debit-card")
            try insert(ID: 15, NAME: "drugs")
            try insert(ID: 16, NAME: "football")
            try insert(ID: 17, NAME: "gas-station")
            try insert(ID: 18, NAME: "gas")
            try insert(ID: 19, NAME: "geography")
            try insert(ID: 20, NAME: "gift")
            try insert(ID: 21, NAME: "groceries")
            try insert(ID: 22, NAME: "heart")
            try insert(ID: 23, NAME: "house")
            try insert(ID: 24, NAME: "money")
            try insert(ID: 25, NAME: "mortarboard")
            try insert(ID: 26, NAME: "motor-sports")
            try insert(ID: 27, NAME: "nurse")
            try insert(ID: 28, NAME: "online-shop-1")
            try insert(ID: 29, NAME: "online-shop")
            try insert(ID: 30, NAME: "paint-palette")
            try insert(ID: 31, NAME: "physics")
            try insert(ID: 32, NAME: "piggy-bank")
            try insert(ID: 33, NAME: "protractor")
            try insert(ID: 34, NAME: "real-estate")
            try insert(ID: 35, NAME: "sale")
            try insert(ID: 36, NAME: "scholarship")
            try insert(ID: 37, NAME: "school-bus")
            try insert(ID: 38, NAME: "shoe")
            try insert(ID: 39, NAME: "shopping-cart")
            try insert(ID: 40, NAME: "smartphone")
            try insert(ID: 41, NAME: "strong")
            try insert(ID: 42, NAME: "swimming-pool")
            try insert(ID: 43, NAME: "transaction")
            try insert(ID: 44, NAME: "trench-coat")
            try insert(ID: 45, NAME: "wallet")
            try insert(ID: 46, NAME: "wifi-signal")
            try insert(ID: 47, NAME: "workspace")
            try insert(ID: 48, NAME: "library")
            try insert(ID: 49, NAME: "browser")
            try insert(ID: 50, NAME: "drop")
            try insert(ID: 51, NAME: "rent")
            try insert(ID: 52, NAME: "groceries-1")
            try insert(ID: 53, NAME: "puzzle")
            try insert(ID: 54, NAME: "popcorn")
            try insert(ID: 55, NAME: "tools")
            try insert(ID: 56, NAME: "discount")
            try insert(ID: 57, NAME: "bonus")
            try insert(ID: 58, NAME: "trophy")
        }catch{
            print("Prepare statement error.")
        }
        
    }
    
    func getName(ID: Int)->String?{
        let SQL = """
                  SELECT NAME
                  FROM ICON
                  WHERE ID = ?
                  """
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                return nil
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
       guard sqlite3_bind_int(queryStatement, 1, Int32(ID)) == SQLITE_OK
        else{
            return nil
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_ROW
            else{
                return nil
        }
        
        guard let queryResult = sqlite3_column_text(queryStatement, 0) else{
            return nil
        }
        let result = String(cString: queryResult) as  String
        return result
    }
    
    func insert(ID: Int, NAME: String) throws{
        let SQL = """
                  INSERT INTO ICON (ID, NAME)
                  VALUES (?, ?)
                  """
        let name = NAME as NSString
        let insertStatement = try Database.shared.connection?.prepareStatement(SQL: SQL)
        defer{
            sqlite3_finalize(insertStatement)
        }
            
        guard sqlite3_bind_int(insertStatement, 1, Int32(ID)) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil) == SQLITE_OK
            else{
                throw SQLiteError.Bind(message: "ICON: Bind error")
        }
            
        guard sqlite3_step(insertStatement) == SQLITE_DONE else{
            throw SQLiteError.Step(message: "ICON: Insert step error")
        }
        print("ICON: Successfully inserted row.")
    }
    
    func count() -> Int{
        let SQL = """
                  SELECT COUNT()
                  FROM ICON
                  """
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                return 0
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
  
        guard sqlite3_step(queryStatement) == SQLITE_ROW
            else{
                return 0
        }
        
        return Int(sqlite3_column_int(queryStatement, 0))
    }
}
