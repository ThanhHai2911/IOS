//
//  Question.swift
//  DoVui
//
//  Created by DoTruongThanh on 16/05/2024.
//

import UIKit

class Question: Codable {
    //MARK:Properties
//    let questionName:String
//    let answers :[String]
//    let correct:Int
//
//    //Mark:contructer
//    init(questionName:String, answers:[String], correct:Int){
//        self.questionName = questionName
//        self.answers = answers
//        self.correct = correct
//    }
//
//
//    static func loadQuestions(from fileName: String) -> [Question]? {
//           if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
//               do {
//                   let data = try Data(contentsOf: url)
//                   let decoder = JSONDecoder()
//                   return try decoder.decode([Question].self, from: data)
//               } catch {
//                   print("Error loading or parsing \(fileName).json: \(error)")
//               }
//           }
//           return nil
//       }
    
    //MARK:Properties
    var id: Int
    var cauhoi: String
    var dapan1: String
    var dapan2: String
    var dapan3: String
    var dapan4: String
    var dapan: Int
    
    //Mark:contructer
    init(id:Int,cauhoi:String,dapan1:String,dapan2: String,dapan3: String,dapan4: String,dapan: Int){
        self.id = id
        self.cauhoi = cauhoi
        self.dapan1 = dapan1
        self.dapan2 = dapan2
        self.dapan3 = dapan3
        self.dapan4 = dapan4
        self.dapan = dapan
     }
    
}
