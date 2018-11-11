//
//  Database.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/11/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import Foundation

class Database{
    static let shared = Database()
    public var connection: SQLiteDatabase? = nil
    private let databaseFilename = "MonneyKeeper.sqlite3"
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
        do{
            connection = try SQLiteDatabase.open(path: "\(path!)/\(databaseFilename)")
            print("Open database successfully.")
        }catch{
            print("cannot open data.")
        }
    }
}
