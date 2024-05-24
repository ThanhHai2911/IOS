//
//  CauHoiController.swift
//  DoVui
//
//  Created by Thanh Hải on 24/05/2024.
//

import Foundation
import UIKit

class CauHoiCotroller: UITableViewController {
    private let db = Database()
    var questions: [Database.Question] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Doc Dl tu CSDL
        questions = db.docDL()
        tableView.reloadData()
        
    }
    // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return questions.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CauHoiCell", for: indexPath)
            let question = questions[indexPath.row]
            cell.textLabel?.text = question.cauhoi
            cell.textLabel?.text = question.dapan1
            cell.textLabel?.text = question.dapan2
            cell.textLabel?.text = question.dapan3
            cell.textLabel?.text = question.dapan4
            cell.textLabel?.text = question.dapan
            return cell
        }

}
