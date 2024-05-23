//
//  Question.swift
//  DoVui
//
//  Created by DoTruongThanh on 16/05/2024.
//

import UIKit

class Question: Codable {
    //MARK:Properties
    let questionName:String
    let answers :[String]
    let correct:Int
    
    //Mark:contructer
    init(questionName:String, answers:[String], correct:Int){
        self.questionName = questionName
        self.answers = answers
        self.correct = correct
    }
    
    
    static func loadQuestions(from fileName: String) -> [Question]? {
           if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
               do {
                   let data = try Data(contentsOf: url)
                   let decoder = JSONDecoder()
                   return try decoder.decode([Question].self, from: data)
               } catch {
                   print("Error loading or parsing \(fileName).json: \(error)")
               }
           }
           return nil
       }
    
}
