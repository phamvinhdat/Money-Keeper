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
                    print("CATEGORY: Create table step error.")
                    return
            }
            print("CATEGORY table created.")
            //insert value
            
        }catch{
            print("CATEGORY: Prepare statement error.")
        }
        
    }
    
    //KIND: 1_Expense, 2_Income
    //PARENTCATEGORY: 0_root
    func insert(ID: Int, NAME: String, IDICON: Int, PARENTCATEGORY: Int, KIND: Int) throws{
        let SQL = """
                  INSERT INTO CATEGORY (ID, NAME, IDICON, PARENTCATEGORY, KIND)
                  VALUES (?, ?, ?, ?, ?)
                  """
        
        let insertStatement = try Database.shared.connection?.prepareStatement(SQL: SQL)
        defer{
            sqlite3_finalize(insertStatement)
        }
        
        let name = NAME as NSString
        guard sqlite3_bind_int(insertStatement, 1, Int32(ID)) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_int(insertStatement, 3, Int32(IDICON)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 4, Int32(PARENTCATEGORY)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 5, Int32(KIND)) == SQLITE_OK
            else{
                throw SQLiteError.Bind(message: "Category bind error.")
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else{
            throw SQLiteError.Step(message: "CATEGORY: Insert step error")
        }
        print("CATEGORY: Successfully inserted row.")
    }
    
    func count() -> Int{
        let SQL = """
                  SELECT COUNT()
                  FROM CATEGORY
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
