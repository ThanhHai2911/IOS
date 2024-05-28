//
//  ViewController.swift
//  DoVui
//
//  Created by Thanh Hải on 13/05/2024.
//

import UIKit

class ViewController: UIViewController{
    

    @IBOutlet weak var dangky: UILabel!
    var receivedText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dangky.text = receivedText
    }
    
    //Chuyen man hinh tu start den question
    @IBAction func startGame(){
        let vc = storyboard?.instantiateViewController(identifier: "game") as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        vc.receivedText = receivedText
        present(vc, animated: true)
    }
    //Thoat ung dung
    @IBAction func thaoUngDung(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "dangky") as! DangKyController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    //Xem bang xep hang
    @IBAction func bangXepHang(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "bangxephang") as! BangXepHangController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

