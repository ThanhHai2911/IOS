//
//  ThongTinController.swift
//  DoVui
//
//  Created by Thanh Hải on 17/05/2024.
//

import UIKit
class ThongTinController: UIViewController{
    var receivedCount: Int = 0
    var notificationMessage: String = ""
    @IBOutlet weak var thongTinDiem: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        thongTinDiem.text = String("Điểm của bạn là: \(receivedCount)")
        messageLabel.text = notificationMessage
    }
    //Quay lai man hinh tra loi cau hoi
    @IBAction func choiLai(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "game") as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    //Thoat ung dung
    @IBAction func thoat(_ sender: UIButton) {
        let alert = UIAlertController(title: "Thoát ứng dụng", message: "Bạn có muốn thoát ứng dụng không?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .destructive, handler: { _ in
                exit(0)
            }))
            self.present(alert, animated: true, completion: nil)
    }
}
