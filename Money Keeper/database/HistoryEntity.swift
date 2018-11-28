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
                  ID INT PRIMARY KEY,
                  TIME DATE,
                  NOTE VARCHAR(500),
                  IDCATEGORY INT NOT NULL,
                  MONEY FLOAT NOT NULL,
                  IDWALLET INT NOT NULL,
                  FOREIGN KEY (IDCATEGORY) REFERENCES CATEGORY(ID),
                  FOREIGN KEY (IDWALLET) REFERENCES WALLET(ID)
                  )
                  """
    
    private init(){
        Database.shared.connection?.CreateTable(SQL: self.CREATETABLE, Complete: nil)
    }
}
