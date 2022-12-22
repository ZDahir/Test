//
//  DBHelper.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 29/04/2022.
//  Copyright © 2022 Zaid Dahir. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "data.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS rhymes(Id INTEGER PRIMARY KEY,title TEXT,desc TEXT, isFavorite INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("rhymes table created.")
            } else {
                print("rhymes table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(title:String, desc:String, isFavorite:Int)
    {
        
        let insertStatementString = "INSERT INTO rhymes (title, desc, isFavorite) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (desc as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(isFavorite))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    func read() -> [Rhymes] {
        let queryStatementString = "SELECT * FROM rhymes;"
        var queryStatement: OpaquePointer? = nil
        var rhymes : [Rhymes] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let desc = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isFavorite = sqlite3_column_int(queryStatement, 3)
                rhymes.append(Rhymes(id: Int(id), title: title, desc: desc, isFavorite: Int(isFavorite)))
                print("Query Result:")
                print("\(id) | \(title) | \(desc)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return rhymes
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM rhymes WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    func updateByID(id:Int, isFavorite: Int) {
        
        let updateStatementStirng = "UPDATE rhymes SET isFavorite=\(isFavorite) WHERE Id = \(id);"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not updated row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    
    
    func updateVerseDetail(id:Int, title:String, desc:String) {
        
        let updateStatementStirng = "UPDATE rhymes SET title = '\(title)', desc = '\(desc)' WHERE Id = \(id);"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not updated row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
}
