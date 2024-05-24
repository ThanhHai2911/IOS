//
//  DangKyController.swift
//  DoVui
//
//  Created by Thanh Hải on 19/05/2024.
//

import UIKit
class DangKyController: UIViewController{


    @IBOutlet weak var textDangKy: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func dangKy(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "manhinhchinh") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        vc.receivedText = textDangKy.text // lay thong tin tu text field qua man hinh moi
            present(vc, animated: true)
    }
}
