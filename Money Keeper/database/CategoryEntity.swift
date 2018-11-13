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
            //insert value default
            try insert(ID: 1, NAME: "Education", IDICON: 25, PARENTCATEGORY: 0, KIND: 0)
            try insert(ID: 2, NAME: "Tuition fee", IDICON: 43, PARENTCATEGORY: 1, KIND: 0)
            try insert(ID: 3, NAME: "Book", IDICON: 48, PARENTCATEGORY: 48, KIND: 0)
            try insert(ID: 4, NAME: "Home", IDICON: 34, PARENTCATEGORY: 0, KIND: 0)
            try insert(ID: 5, NAME: "Internet", IDICON: 46, PARENTCATEGORY: 4, KIND: 0)
            try insert(ID: 6, NAME: "Water and electricity", IDICON: 50, PARENTCATEGORY: 4, KIND: 0)
            try insert(ID: 7, NAME: "Rent", IDICON: 51, PARENTCATEGORY: 4, KIND: 0)
            try insert(ID: 8, NAME: "Health & Fitness", IDICON: 22, PARENTCATEGORY: 0, KIND: 0)
            try insert(ID: 9, NAME: "Doctor", IDICON: 27, PARENTCATEGORY: 8, KIND: 0)
            try insert(ID: 10, NAME: "Pharmacy", IDICON: 15, PARENTCATEGORY: 8, KIND: 0)
            try insert(ID: 11, NAME: "Food", IDICON: 21, PARENTCATEGORY: 0, KIND: 0)
            try insert(ID: 12, NAME: "Entertainment", IDICON: 53, PARENTCATEGORY: 0, KIND: 0)
            try insert(ID: 13, NAME: "Movies", IDICON: 54, PARENTCATEGORY: 12, KIND: 0)
            try insert(ID: 14, NAME: "Travel", IDICON: 5, PARENTCATEGORY: 12, KIND: 0)
            try insert(ID: 15, NAME: "Shopping", IDICON: 28, PARENTCATEGORY: 0, KIND: 0)
            try insert(ID: 16, NAME: "Clothes", IDICON: 44, PARENTCATEGORY: 15, KIND: 0)
            try insert(ID: 17, NAME: "Transport", IDICON: 19, PARENTCATEGORY: 0, KIND: 0)
            try insert(ID: 18, NAME: "Fuel", IDICON: 17, PARENTCATEGORY: 17, KIND: 0)
            try insert(ID: 19, NAME: "Repair vehicles", IDICON: 55, PARENTCATEGORY: 17, KIND: 0)
            try insert(ID: 20, NAME: "Salary", IDICON: 24, PARENTCATEGORY: 0, KIND: 1)
            try insert(ID: 21, NAME: "Savings interest", IDICON: 56, PARENTCATEGORY: 0, KIND: 1)
            try insert(ID: 22, NAME: "Bonus", IDICON: 57, PARENTCATEGORY: 0, KIND: 1)
            try insert(ID: 23, NAME: "Awarded", IDICON: 58, PARENTCATEGORY: 0, KIND: 1)
            try insert(ID: 24, NAME: "Other", IDICON: 4, PARENTCATEGORY: 0, KIND: 1)
            
        }catch{
            print("CATEGORY: Prepare statement error.")
        }
        
    }
    
    //KIND: 0_Expense, 1_Income
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
