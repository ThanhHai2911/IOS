//
//  DangKyController.swift
//  DoVui
//
//  Created by Thanh Hải on 19/05/2024.
//

import UIKit
class DangKyController: UIViewController{

    private let db = Database()
    @IBOutlet weak var textDangKy: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func dangKy(_ sender: Any) {
        guard let textName = textDangKy.text, !textName.isEmpty else {
            // Thong bao loi neu 1 trong cac truong de trong
              let alert = UIAlertController(title: "Lỗi", message: "Vui lòng điền đầy đủ thông tin.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
            return
        }
                
        // them du lieu
        db.themNguoiDung(username: textName)
        print("Them nguoi dung thanh cong")
        
        let vc = storyboard?.instantiateViewController(identifier: "manhinhchinh") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        vc.receivedText = textDangKy.text // lay thong tin tu text field qua man hinh moi
            present(vc, animated: true)
    }
}
