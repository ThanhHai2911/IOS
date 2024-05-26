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
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var diem: UILabel!
    var users: [User] = []
    var count: [Count] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        hienThiNguoiDung()
        hienThiDiem()
    }
    //Ham hien thi ten nguoi dung
    func hienThiNguoiDung(){
        users = db.docNguoiDung()
        if users.isEmpty {
            name.text = "Không có dữ liệu người dùng"
        } else {
            var userText = ""
            for user in users {
                userText += "\(user.username)\n\n"
            }
            name.text = userText
        }
    }
    //Ham hien thi diem cua nguoi dung
    func hienThiDiem(){
        count = db.docDiem()
        if count.isEmpty {
            diem.text = "Không diem người dùng"
        } else {
            var countText = ""
            for diem in count {
                countText += "\(diem.count)\n\n"
            }
            diem.text = countText
        }
    }
}
