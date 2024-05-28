//
//  BangXepHangController.swift
//  DoVui
//
//  Created by Thanh Hải on 26/05/2024.
//

import Foundation
import UIKit
class BangXepHangController:UIViewController{
    private let db = Database()

    @IBOutlet weak var name: UITextView!
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       hienThiNguoiDung()
    }
//    Ham hien thi ten nguoi dung
    func hienThiNguoiDung(){
       users = db.docNguoiDung()
       if users.isEmpty {
            name.text = "Không có dữ liệu người dùng"
        } else {
           //Hien thi toan bo du lieu co trong csdl
            var userText = ""
            for user in users {
                userText += "\(user.username) - \(user.count)\n"
            }
            name.text = userText
        }
    }
    @IBAction func thoat(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "manhinhchinh") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}
