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
        present(vc, animated: true)
    }
    //Thoat ung dung
    @IBAction func thoatUngDung(_ sender: UIButton) {
        let alert = UIAlertController(title: "Thoát ứng dụng", message: "Bạn có muốn thoát ứng dụng không?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .destructive, handler: { _ in
                exit(0)
            }))
            self.present(alert, animated: true, completion: nil)

    }
}

