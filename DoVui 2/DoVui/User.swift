//
//  User.swift
//  DoVui
//
//  Created by TruongThanh on 26/05/2024.
//

import UIKit
class User:Codable{
    ///MARK:Properties
    var id:Int
    var username:String
    var count:Int
    //MARK:Properties
    init(id:Int,username:String,count:Int){
        self.id = id
        self.username = username
        self.count = count
    }
    
}
