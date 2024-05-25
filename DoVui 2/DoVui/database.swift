//
//  database.swift
//  DoVui
//
//  Created by Thanh Hải on 19/05/2024.
//

import SQLite3

class DatabaseHelper {
    static let shared = DatabaseHelper()
    private let db: Connection?

    private let questions = Table("questions")
    private let id = Expression<Int64>("id")
    private let questionText = Expression<String>("question_text")

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            db = nil
            print("Unable to open database")
        }
    }

    func createTable() throws {
        do {
            try db?.run(questions.create { t in
                t.column(id, primaryKey: true)
                t.column(questionText)
            })
        } catch {
            print("Unable to create table")
        }
    }

    func insertQuestion(text: String) -> Int64? {
        do {
            let insert = questions.insert(self.questionText <- text)
            let id = try db?.run(insert)
            return id
        } catch {
            print("Insert failed")
            return nil
        }
    }
}

