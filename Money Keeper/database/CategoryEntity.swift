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
    
    private let CREATETABLE = """
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
    
    private init(){
        do{
            try Database.shared.connection?.CreateTable(SQL: self.CREATETABLE, Complete: self.defaultInsert)
        }catch let er{
            print(er)
        }
    }
    
    private func defaultInsert(){
        do{
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
        }catch let er{
            print(er)
        }
    }
    
    //PARENTCATEGORY: 0_root
    public func insert(ID: Int, NAME: String, IDICON: Int, PARENTCATEGORY: Int, KIND: Kind) throws{
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
    
    public func count() -> Int{
        do {
            let count = try Database.shared.connection?.count("CATEGORY", nil)
            return count ?? 0
        }catch let er{
            print(er)
            return 0
        }
    }
    
    public func count(KIND: Kind) -> Int{
        do {
            let count = try Database.shared.connection?.count("CATEGORY",  "KIND = \(KIND.rawValue)")
            return count ?? 0
        }catch let er{
            print(er)
            return 0
        }
    }
    
    public func getName(ID: Int)->String?{
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
    
    public func getIntPropertybyID(ID: Int, property: IntProperty) -> Int?{
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
                print(Database.shared.connection!.errorMessage)
                return nil
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_bind_int(queryStatement, 1, Int32(ID)) == SQLITE_OK
            else{
                print(Database.shared.connection!.errorMessage)
                return nil
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_ROW
            else{
                print(Database.shared.connection!.errorMessage)
                return nil
        }
        return Int(sqlite3_column_int(queryStatement, 0))
    }
    
    public func getCategories(KIND: Kind) -> [Category]{
        var tblCategory = [Category]()
        let SQL = "SELECT* FROM CATEGORY C WHERE C.KIND = ?"
        guard let queryStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL)
            else{
                print(Database.shared.connection!.errorMessage)
                return tblCategory
        }
        defer{
            sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_bind_int(queryStatement, 1, Int32(KIND.rawValue)) == SQLITE_OK
            else{
                print(Database.shared.connection!.errorMessage)
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
    
    public func update(ID: Int, _ property: IntProperty, value: Int) -> Bool{
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
            print(Database.shared.connection!.errorMessage)
            return false
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        guard sqlite3_bind_int(updateStatement, 1, Int32(value)) == SQLITE_OK && sqlite3_bind_int(updateStatement, 2, Int32(ID)) == SQLITE_OK
            else{
                print(Database.shared.connection!.errorMessage)
                return false
        }
        
        guard sqlite3_step(updateStatement) == SQLITE_ROW
            else{
                print(Database.shared.connection!.errorMessage)
                return false
        }
        
        print("CATEGORY: Update successfully.")
        return true
    }
    
    public func update(ID: Int, NAME: String) -> Bool{
        var SQL = """
                  UPDATE CATEGORY
                  SET NAME = ?
                  WHERE ID = ?
                  """
        
        guard let updateStatement = try? Database.shared.connection?.prepareStatement(SQL: SQL) else{
            print(Database.shared.connection!.errorMessage)
            return false
        }
        defer{
            sqlite3_finalize(updateStatement)
        }
        
        let name = NAME as NSString
        guard sqlite3_bind_text(updateStatement, 1, name.utf8String, -1, nil) == SQLITE_OK && sqlite3_bind_int(updateStatement, 2, Int32(ID)) == SQLITE_OK
            else{
                print(Database.shared.connection!.errorMessage)
                return false
        }
        
        guard sqlite3_step(updateStatement) == SQLITE_ROW
            else{
                print(Database.shared.connection!.errorMessage)
                return false
        }
        
        print("CATEGORY: Update successfully.")
        return true
    }
    
    func remove(id: Int) -> Bool{
        do{
            try Database.shared.connection?.remove("CATEGORY", id: id)
            return true
        }catch let er{
            print(er)
            return false
        }
    }
}

class Category{
    var id:Int
    var name:String
    var idIcon:Int
    var parentCategory:Int
    var kind = Kind.income
    
    init() {
        id = Int()
        name = String()
        idIcon = Int()
        parentCategory = Int()
    }
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
