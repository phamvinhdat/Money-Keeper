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
            try insert(ID: 1, NAME: "Education", IDICON: 25, PARENTCATEGORY: 0, KIND: .expense)
            try insert(ID: 2, NAME: "Tuition fee", IDICON: 43, PARENTCATEGORY: 1, KIND: .expense)
            try insert(ID: 3, NAME: "Book", IDICON: 48, PARENTCATEGORY: 48, KIND: .expense)
            try insert(ID: 4, NAME: "Home", IDICON: 34, PARENTCATEGORY: 0, KIND: .expense)
            try insert(ID: 5, NAME: "Internet", IDICON: 46, PARENTCATEGORY: 4, KIND: .expense)
            try insert(ID: 6, NAME: "Water and electricity", IDICON: 50, PARENTCATEGORY: 4, KIND: .expense)
            try insert(ID: 7, NAME: "Rent", IDICON: 51, PARENTCATEGORY: 4, KIND: .expense)
            try insert(ID: 8, NAME: "Health & Fitness", IDICON: 22, PARENTCATEGORY: 0, KIND: .expense)
            try insert(ID: 9, NAME: "Doctor", IDICON: 27, PARENTCATEGORY: 8, KIND: .expense)
            try insert(ID: 10, NAME: "Pharmacy", IDICON: 15, PARENTCATEGORY: 8, KIND: .expense)
            try insert(ID: 11, NAME: "Food", IDICON: 21, PARENTCATEGORY: 0, KIND: .expense)
            try insert(ID: 12, NAME: "Entertainment", IDICON: 53, PARENTCATEGORY: 0, KIND: .expense)
            try insert(ID: 13, NAME: "Movies", IDICON: 54, PARENTCATEGORY: 12, KIND: .expense)
            try insert(ID: 14, NAME: "Travel", IDICON: 5, PARENTCATEGORY: 12, KIND: .expense)
            try insert(ID: 15, NAME: "Shopping", IDICON: 28, PARENTCATEGORY: 0, KIND: .expense)
            try insert(ID: 16, NAME: "Clothes", IDICON: 44, PARENTCATEGORY: 15, KIND: .expense)
            try insert(ID: 17, NAME: "Transport", IDICON: 19, PARENTCATEGORY: 0, KIND: .expense)
            try insert(ID: 18, NAME: "Fuel", IDICON: 17, PARENTCATEGORY: 17, KIND: .expense)
            try insert(ID: 19, NAME: "Repair vehicles", IDICON: 55, PARENTCATEGORY: 17, KIND: .expense)
            try insert(ID: 20, NAME: "Salary", IDICON: 24, PARENTCATEGORY: 0, KIND: .income)
            try insert(ID: 21, NAME: "Savings interest", IDICON: 56, PARENTCATEGORY: 0, KIND: .income)
            try insert(ID: 22, NAME: "Bonus", IDICON: 57, PARENTCATEGORY: 0, KIND: .income)
            try insert(ID: 23, NAME: "Awarded", IDICON: 58, PARENTCATEGORY: 0, KIND: .income)
            try insert(ID: 24, NAME: "Other", IDICON: 4, PARENTCATEGORY: 0, KIND: .income)
            
        }catch{
            print("CATEGORY: Prepare statement error.")
        }
        
    }
    
    //PARENTCATEGORY: 0_root
    func insert(ID: Int, NAME: String, IDICON: Int, PARENTCATEGORY: Int, KIND: Kind) throws{
        let SQL = """
                  INSERT INTO CATEGORY (ID, NAME, IDICON, PARENTCATEGORY, KIND)
                  VALUES (?, ?, ?, ?, ?)
                  """
        
        let insertStatement = try Database.shared.connection?.prepareStatement(SQL: SQL)
        defer{
            sqlite3_finalize(insertStatement)
        }
        
        let name = NAME as NSString
        guard sqlite3_bind_int(insertStatement, 1, Int32(ID)) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_int(insertStatement, 3, Int32(IDICON)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 4, Int32(PARENTCATEGORY)) == SQLITE_OK && sqlite3_bind_int(insertStatement, 5, Int32(KIND.rawValue)) == SQLITE_OK
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
                print("CATEGORY: Count prepare statement fail.")
                return 0
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_ROW
            else{
                print("CATEGORY: Count step fail.")
                return 0
        }
        return Int(sqlite3_column_int(queryStatement, 0))
    }
    
    func count(KIND: Kind) -> Int{
        let SQL = "SELECT COUNT() FROM CATEGORY C WHERE C.KIND = ?"
        
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                print("CATEGORY: Count prepare statement fail.")
                return 0;
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_bind_int(queryStatement, 1, Int32(KIND.rawValue)) == SQLITE_OK
            else{
                print("CATEGORY: Count bind fail.")
                return 0;
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_ROW
            else{
                print("CATEGORY: Count step fail.")
                return 0
        }
        return Int(sqlite3_column_int(queryStatement, 0))
    }
    
    func getName(ID: Int)->String?{
        let SQL = """
                  SELECT NAME
                  FROM CATEGORY
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
    
    func getIntPropertybyID(ID: Int, property: IntProperty) -> Int?{
        var SQL:String? = nil
        
        switch property{
        case .IDIcon:
            SQL = "SELECT C.IDICON FROM CATEGORY C WHERE C.ID = ?"
            break
        case .kind:
            SQL = "SELECT C.KIND FROM CATEGORY C WHERE C.ID = ?"
            break
        case .parentCategory:
            SQL = "SELECT C.PARENTCATEGORY FROM CATEGORY C WHERE C.ID = ?"
            break
        }
        
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL!)
            else{
                print("CATEGORY: getIntPropertybyID prepare statement fail.")
                return nil
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_bind_int(queryStatement, 1, Int32(ID)) == SQLITE_OK
            else{
                print("CATEGORY: getIntPropertybyID bind fail.")
                return nil
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_ROW
            else{
                print("CATEGORY: getIntPropertybyID step fail.")
                return nil
        }
        return Int(sqlite3_column_int(queryStatement, 0))
    }
    
    func getTblCategory(KIND: Kind) -> [Category]{
        var tblCategory = [Category]()
        let SQL = "SELECT* FROM CATEGORY C WHERE C.KIND = ?"
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                print("CATEGORY: getTblCategory prepare statement fail.")
                return tblCategory
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_bind_int(queryStatement, 1, Int32(KIND.rawValue)) == SQLITE_OK
            else{
                return tblCategory
        }
        
        while sqlite3_step(queryStatement) == SQLITE_ROW{
            let category = Category()
            category.id = Int(sqlite3_column_int(queryStatement, 0))
            let queryTemp = sqlite3_column_text(queryStatement, 1)
            category.name = String(cString: queryTemp!)
            category.idIcon = Int(sqlite3_column_int(queryStatement, 2))
            category.parentCategory = Int(sqlite3_column_int(queryStatement, 3))
            let kindTemp = Int(sqlite3_column_int(queryStatement, 4))
            if kindTemp == Kind.expense.rawValue{
                category.kind = .expense
            }else{
                category.kind = .income
            }
            tblCategory.append(category)
        }

        return tblCategory
    }
    
    func update(ID: Int, _ property: IntProperty, value: Int) -> Bool{
        var SQL: String!
        
        switch property{
        case .IDIcon:
            SQL = """
                  UPDATE CATEGORY
                  SET IDICON = ?
                  WHERE ID = ?
                  """
            break
        case .kind:
            SQL = """
                  UPDATE CATEGORY
                  SET KIND = ?
                  WHERE ID = ?
                  """
            break
        case .parentCategory:
            SQL = """
                  UPDATE CATEGORY
                  SET PARENTCATEGORY = ?
                  WHERE ID = ?
                  """
            break
        }
        
        guard let updateStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL) else{
            print("CATEGORY: update prepare statement fail.")
            return false
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        guard sqlite3_bind_int(updateStatement, 1, Int32(value)) == SQLITE_OK && sqlite3_bind_int(updateStatement, 2, Int32(ID)) == SQLITE_OK
            else{
                print("CATEGORY: update bind fail.")
                return false
        }
        
        guard sqlite3_step(updateStatement) == SQLITE_ROW
            else{
                print("CATEGORY: update step fail.")
                return false
        }
        
        print("CATEGORY: Update successfully.")
        return true
    }
    
    func update(ID: Int, NAME: String) -> Bool{
        var SQL = """
                  UPDATE CATEGORY
                  SET NAME = ?
                  WHERE ID = ?
                  """
        
        guard let updateStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL) else{
            print("CATEGORY: update prepare statement fail.")
            return false
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        let name = NAME as NSString
        guard sqlite3_bind_text(updateStatement, 1, name.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_int(updateStatement, 2, Int32(ID)) == SQLITE_OK
            else{
                print("CATEGORY: update bind fail.")
                return false
        }
        
        guard sqlite3_step(updateStatement) == SQLITE_ROW
            else{
                print("CATEGORY: update step fail.")
                return false
        }
        
        print("CATEGORY: Update successfully.")
        return true
    }
    
    func remove(id: Int) -> Bool{
        let SQL = """
                  DELETE FROM CATEGORY
                  WHERE ID = ?
                  """
        guard let removeStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                print("CATEGORY: remove prepare statement fail.")
                return false
        }
        defer{
            sqlite3_finalize(removeStatement)
        }
        
        guard sqlite3_bind_int(removeStatement, 1, Int32(id)) == SQLITE_OK
            else{
                print("CATEGORY: remove bind fail.")
                return false
        }
        
        guard sqlite3_step(removeStatement) == SQLITE_DONE else{
            print("CATEGORY: remove step fail.")
            return false
        }
        print("CATEGORY remove successfully.")
        return true
    }
}

class Category{
    var id = Int()
    var name = String()
    var idIcon = Int()
    var parentCategory = Int()
    var kind = Kind.income
}

enum Kind: Int{
    case expense
    case income
}

enum IntProperty: Int{
    case IDIcon
    case parentCategory
    case kind
}
