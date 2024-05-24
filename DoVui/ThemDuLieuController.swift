//
//  ThemDuLieuController.swift
//  DoVui
//
//  Created by Thanh Hải on 21/05/2024.
//

import Foundation
import UIKit
class ThemDuLieuController:UIViewController{
    //Dinh nghia doi tuong truy xuat CSDL
    private let db = Database()
    private let cauHoiID = "cauhoi"
    @IBOutlet weak var cauHoi: UITextField!
    @IBOutlet weak var dapan1: UITextField!
    @IBOutlet weak var dapAn2: UITextField!
    @IBOutlet weak var dapAn3: UITextField!
    @IBOutlet weak var dapAn4: UITextField!
    @IBOutlet weak var dapAnDung: UITextField!
    override func viewDidLoad() {
            super.viewDidLoad()
        cauHoi.text = ""
        dapan1.text = ""
        dapAn2.text = ""
        dapAn3.text = ""
        dapAn4.text = ""
        dapAnDung.text = ""
        }
    
    @IBAction func themDL(_ sender: UIButton) {
        // Lay du lieu tu UITextField
        guard let cauHoiText = cauHoi.text, !cauHoiText.isEmpty,
              let dapan1Text = dapan1.text, !dapan1Text.isEmpty,
              let dapAn2Text = dapAn2.text, !dapAn2Text.isEmpty,
              let dapAn3Text = dapAn3.text, !dapAn3Text.isEmpty,
              let dapAn4Text = dapAn4.text, !dapAn4Text.isEmpty,
              let dapAnDungText = dapAnDung.text, !dapAnDungText.isEmpty else {
            // Thong bao loi neu 1 trong cac truong de trong
              let alert = UIAlertController(title: "Lỗi", message: "Vui lòng điền đầy đủ thông tin.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
            return
        }
                
        // them du lieu
        db.themDL(cauhoi: cauHoiText, dapan1: dapan1Text, dapan2: dapAn2Text, dapan3: dapAn3Text, dapan4: dapAn4Text, dapan: dapAnDungText)
        // Thong bao khi them thanh cong
        let alert = UIAlertController(title: "Thành công", message: "Đã thêm câu hỏi thành công.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
                
        // xoa du lieu trong textfield khi them thanh cong
        cauHoi.text = ""
        dapan1.text = ""
        dapAn2.text = ""
        dapAn3.text = ""
        dapAn4.text = ""
        dapAnDung.text = ""
    }

    
}
