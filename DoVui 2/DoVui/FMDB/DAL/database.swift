//
//  database.swift
//  DoVui
//
//  Created by Thanh Hải on 21/05/2024.
//

import Foundation
import UIKit
import os.log

class Database{
    //MARK: Cac thuoc tinh chung cu csdl
    private let DB_NAME = "dovui.sqlite"
    private let DB_PATH:String?
    private let database:FMDatabase?
    //MARK: Thuoc tinh cua cac bang csdl
    //1.Bang meal
    private let MEAL_TABLE_NAME = "dovui"
    private let ID = "id"
    private let NAME = "cauhoi"
    private let DAPANA = "dapan1"
    private let DAPANB = "dapan2"
    private let DAPANC = "dapan3"
    private let DAPAND = "dapan4"
    private let DAPAN = "dapan"
    
    //MARK: Constructors
    init(){
        //Lay ve tat ca cac thu muc lien quan den document cua ung dung ios
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        //Khoi tao DB_PATH
        DB_PATH = directories[0] + "/" + DB_NAME
        //Khoi tao CSDL
        database = FMDatabase(path: DB_PATH)
        //Kiem tra su thanh cong cua khoi tao csdl
        if database != nil{
            os_log("Khoi tao csdl thanh cong")
            //Thuc hien tao cac bang du lieu
            //1.Bang meals
            let sql = "CREATE TABLE \(MEAL_TABLE_NAME)("
            + "\(ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(NAME) TEXT, "
            + "\(DAPANA) TEXT, "
            + "\(DAPANB) TEXT, "
            + "\(DAPANC) TEXT, "
            + "\(DAPAND) TEXT, "
            + "\(DAPAN) TEXT)"
            let _ = tableCrerate(sql: sql, tableName: MEAL_TABLE_NAME)
        }else{
            os_log("Khi tao csdl khong thanh cong")
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham primities cua CSDL
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //1.Mo CSDL
    private func open()->Bool{
        var OK = false
        if database != nil{
            if database!.open(){
                os_log("Mo thanh cong")
                OK = true
            }else{
                os_log("Mo khong thanh cong")
            }
        }
        return OK
    }
    //2. Dong CSDL
    private func close(){
        if database != nil{
            database!.close()
        }
    }
    //3.Tao bang du lieu
    private func tableCrerate(sql:String, tableName:String) -> Bool{
        var OK = false
        if open(){
            if !database!.tableExists(tableName){
               if database!.executeStatements(sql){
                  os_log("Tao bang du lieu \(tableName) thanh cong")
               }else{
                   os_log("Tao bang du lieu \(tableName) khong thanh cong")
               }
            }
        }
        return OK
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham AIPS cua CSDL
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Them cau hoi vao CSDL
    func themDL(cauhoi: String, dapan1: String, dapan2: String, dapan3: String, dapan4: String, dapan: String) {
            if open() {
                let sql = "INSERT INTO \(MEAL_TABLE_NAME) (\(NAME), \(DAPANA), \(DAPANB), \(DAPANC), \(DAPAND), \(DAPAN)) VALUES (?, ?, ?, ?, ?, ?)"
                do {
                    try database!.executeUpdate(sql, values: [cauhoi, dapan1, dapan2, dapan3, dapan4, dapan])
                    os_log("Them cau hoi thanh cong")
                } catch {
                    os_log("Them cau hoi khong thanh cong")
                }
                close()
            }
        }
    //Hien thi cau hoi
    func docDL() -> [Question] {
            var questions = [Question]()
            if open() {
                let sql = "SELECT * FROM \(MEAL_TABLE_NAME)"
                do {
                    let results = try database!.executeQuery(sql, values: nil)
                    while results.next() {
                        let id = Int(results.int(forColumn: ID))
                        let cauhoi = results.string(forColumn: NAME) ?? ""
                        let dapan1 = results.string(forColumn: DAPANA) ?? ""
                        let dapan2 = results.string(forColumn: DAPANB) ?? ""
                        let dapan3 = results.string(forColumn: DAPANC) ?? ""
                        let dapan4 = results.string(forColumn: DAPAND) ?? ""
                        let dapan = results.string(forColumn: DAPAN) ?? ""
                        
                        let question = Question(id: id, cauhoi: cauhoi, dapan1: dapan1, dapan2: dapan2, dapan3: dapan3, dapan4: dapan4, dapan: dapan)
                        questions.append(question)
                    }
                } catch {
                    os_log("Doc du lieu khong thanh cong")
                }
                close()
            }
            return questions
        }
    struct Question {
        var id: Int
        var cauhoi: String
        var dapan1: String
        var dapan2: String
        var dapan3: String
        var dapan4: String
        var dapan: String
    }
}

