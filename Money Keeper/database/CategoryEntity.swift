//
//  CategoryEntity.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/11/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import Foundation

class CategoryEntity{
    static let shared = CategoryEntity()
    
    private init(){
        let SQL = """
                  CREATE TABLE CATEGORY (
                  ID INT PRIMARY KEY,
                  NAME VARCHAR(500) NOT NULL,
                  IDICON INT NOT NULL,
                  PARENTCATEGORY INT,
                  KIND INT CHECK(KIND IN (0, 1)),
                  FOREIGN KEY (IDICON) REFERENCES ICON(ID),
                  FOREIGN KEY (PARENTCATEGORY) REFERENCES CATEGORY(ID)
                  )
                  """
        
        do{
            let statement = try Database.shared.connection?.prepareStatement(SQL: SQL)
            guard sqlite3_step(statement) == SQLITE_DONE
                else{
                    print("Create category table step error.")
                    return
            }
            print("CATEGORY table created.")
            //insert value
            
        }catch{
            print("Prepare statement error.")
        }
        
    }
    
    func insert(ID: Int, NAME: String) throws{
        let SQL = """
                  INSERT INTO CATEGORY (ID, NAME, IDICON, PARENTCATEGORY, KIND)
                  VALUES (?, ?, ?, ?, ?)
                  """
        let name = NAME as NSString
        let insertStatement = try Database.shared.connection?.prepareStatement(SQL: SQL)
        defer{
            sqlite3_finalize(insertStatement)
        }
        
        guard sqlite3_bind_int(insertStatement, 1, Int32(ID)) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil) == SQLITE_OK
            else{
                throw SQLiteError.Bind(message: "Bind error")
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else{
            throw SQLiteError.Step(message: "Insert step error")
        }
        print("Successfully inserted row.")
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
