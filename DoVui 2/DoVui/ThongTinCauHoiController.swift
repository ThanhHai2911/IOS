//
//  ThongTinCauHoiController.swift
//  DoVui
//
//  Created by Thanh Hải on 23/05/2024.
//

import Foundation
import UIKit

class ThongTinCauHoiContronller: UITableViewController{
    //Dinh nghia doi tuong truy xuat CSDL
    private let db = Database()

    var questions: [Question] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Doc Dl tu CSDL

    }
}
