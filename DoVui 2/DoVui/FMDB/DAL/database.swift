//
//  database.swift
//  DoVui
//
//  Created by Thanh Hải on 21/05/2024.
//

import Foundation
import UIKit
import os.log

class Database{
    //MARK: Cac thuoc tinh chung cu csdl
    private let DB_NAME = "dovui.sqlite"
    private let DB_PATH:String?
    private let database:FMDatabase?
    //MARK: Thuoc tinh cua cac bang csdl
    //1.Bang cau hoi
    private let MEAL_TABLE_NAME = "dovui"
    private let ID = "id"
    private let NAME = "cauhoi"
    private let DAPANA = "dapan1"
    private let DAPANB = "dapan2"
    private let DAPANC = "dapan3"
    private let DAPAND = "dapan4"
    private let DAPAN = "dapan"
    //2. Bang thong tin nguoi dung
    private let USER_TABLE_NAME = "users"
    private let USER_ID = "user_id"
    private let USERNAME = "name"
    private let COUNT = "count"

    //MARK: Constructors
    init(){
        //Lay ve tat ca cac thu muc lien quan den document cua ung dung ios
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        //Khoi tao DB_PATH
        DB_PATH = directories[0] + "/" + DB_NAME
        //Khoi tao CSDL
        database = FMDatabase(path: DB_PATH)
        //Kiem tra su thanh cong cua khoi tao csdl
        if database != nil{
            os_log("Khoi tao csdl thanh cong")
            //Thuc hien tao cac bang du lieu
            //1.Bang meals
            let sql = "CREATE TABLE \(MEAL_TABLE_NAME)("
            + "\(ID) INTEGER PRIMARY KEY AUTOINCREMENT, "
            + "\(NAME) TEXT, "
            + "\(DAPANA) TEXT, "
            + "\(DAPANB) TEXT, "
            + "\(DAPANC) TEXT, "
            + "\(DAPAND) TEXT, "
            + "\(DAPAN) INTEGER)"
            let _ = tableCrerate(sql: sql, tableName: MEAL_TABLE_NAME)
            // 2. Bang users
            let sql2 = """
            CREATE TABLE IF NOT EXISTS \(USER_TABLE_NAME) (
                \(USER_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                \(USERNAME) TEXT,
                 \(COUNT) INTEGER)
            """
            let _ = tableCrerate(sql: sql2, tableName: USER_TABLE_NAME)
        
            //Them cau hoi mac dinh
            //themDulieu()
            
            //Xoa toan bo du lieu trong databse
            //xoaToanBoDL()
            
            //Xoa toan bo du lieu nguoi dung
            //xoaToanBoNguoiDung()
         
            
        }else{
            os_log("Khi tao csdl khong thanh cong")
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham primities cua CSDL
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //1.Mo CSDL
    private func open()->Bool{
        var OK = false
        if database != nil{
            if database!.open(){
                os_log("Mo thanh cong")
                OK = true
            }else{
                os_log("Mo khong thanh cong")
            }
        }
        return OK
    }
    //2. Dong CSDL
    private func close(){
        if database != nil{
            database!.close()
        }
    }
    //3.Tao bang du lieu
    private func tableCrerate(sql:String, tableName:String) -> Bool{
        var OK = false
        if open(){
            if !database!.tableExists(tableName){
               if database!.executeStatements(sql){
                  os_log("Tao bang du lieu \(tableName) thanh cong")
               }else{
                   os_log("Tao bang du lieu \(tableName) khong thanh cong")
               }
            }
        }
        return OK
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Dinh nghia cac ham AIPS cua CSDL
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Them cau hoi vao CSDL
    func themDL(cauhoi: String, dapan1: String, dapan2: String, dapan3: String, dapan4: String, dapan: String) {
            if open() {
                let sql = "INSERT INTO \(MEAL_TABLE_NAME) (\(NAME), \(DAPANA), \(DAPANB), \(DAPANC), \(DAPAND), \(DAPAN)) VALUES (?, ?, ?, ?, ?, ?)"
                do {
                    try database!.executeUpdate(sql, values: [cauhoi, dapan1, dapan2, dapan3, dapan4, dapan])
                    os_log("Them cau hoi thanh cong")
                } catch {
                    os_log("Them cau hoi khong thanh cong")
                }
                close()
            }
        }
    //Them du lieu mac dinh vao database
    private func themDulieu() {
        let defaultQuestions = [
            ("Đuôi thì chẳng thấy, mà có hai đầu?", "Cây cầu", "Con rắn", "Con chó", "Con mèo", "0"),
            ("Cái gì không có chân, không có đuôi, không có cơ thể mà có nhiều đầu?", "Cái bàn", "Cầu truyền hình", "Cái ghế", "Cái xe", "1"),
            ("Ba của Tèo gọi mẹ của Tý là em dâu, vậy ba của Tý gọi ba của Tèo là gì?", "Gọi là em trai", "Gọi là bác", "Gọi là anh trai", "Gọi là chú", "2"),
            ("Phía trước bạn là quảng trường xanh, sau lưng bạn là quảng trường trắng, vậy quảng trường đỏ ở đâu?", "Ở Mỹ", "Ở Đức", "Ở Nhật Bản", "Ở Nga", "3"),
            ("Vào tháng nào con người sẽ ngủ ít nhất trong năm?", "Tháng 2", "Tháng 5", "Tháng 1", "Tháng 10", "0"),
            ("Loại xe không có bánh thường thấy ở đâu?", "Trên đường", "Trên bàn cờ vua", "Trên trần nhà", "Trên máy bay", "1"),
            ("Nhà nào lạnh lẽo nhưng ai cũng muốn tới?", "Nhà nghỉ", "Nhà hàng", "Nhà băng", "Nhà sách", "2"),
            ("Hôn mà bị hôn lại gọi là gì?", "Hôn môi", "Hôn má", "Hôn tay", "Đính hôn", "3"),
            ("Tôi chu du khắp thế giới mà tôi vẫn ở nguyên một chỗ, tôi là ai?", "Tem thư", "Người du lịch", "Người lái xe", "Người đi bộ", "0"),
            ("Từ nào trong tiếng Việt có chín mẫu tự h?", "Chính trị", "Chính", "Chính sách", "Chính phủ", "1"),
            ("Bánh gì nghe tên đã thấy sung sướng?", "Bánh Khoái", "Bánh bao", "Bánh mì", "Bánh xèo", "0"),
            ("Bánh gì nghe tên đã thấy đau?", "Bánh bao", "Bánh Tét", "Bánh mì", "Bánh xèo", "1"),
            ("Thứ gì mỗi ngày phải gỡ ra mới có công dụng?", "Đồng hồ", "Máy tính", "Lịch treo tường", "Điện thoại", "2"),
            ("Cái gì luôn chạy không chờ ta bao giờ. Nhưng chúng ta vẫn có thể đứng một chỗ để chờ xem nó?", "Đồng hồ", "Xe bus", "Xe khách", "Xe đạp", "0"),
            ("Con gì biết đi nhưng người ta vẫn nói nó không biết đi?", "Con người", "Con bò", "Con mèo", "Con chó", "1"),
            ("Xe nào không bao giờ giảm đi?", "Xe máy", "Xe đạp", "Xe tăng", "Xe bus", "2"),
            ("Cái gì khi xài thì quăng đi, nhưng khi không xài thì lấy lại?", "Mỏ neo", "Điện thoại", "Máy tính", "Đồng hồ", "0"),
            ("Ở đâu 1 con mã có thể ăn 1 cái xe?", "Trong rừng", "Cờ tướng", "Trong sở thú", "Trên đường", "1"),
            ("Cây nhang càng đốt càng ngắn. Vậy cây gì càng đốt nhiều càng dài?", "Cây thông", "Cây cỏ", "Cây tre", "Cây bàng", "2"),
            ("Hạt đường, hạt cát, hạt gạo, hạt mè, hạt nào dài hơn?", "Hạt đường", "Hạt cát", "Hạt gạo", "Hạt mè", "0"),
            ("Hoa gì bỏ đầu thành tên quốc gia, mất đuôi ra một loài chim?", "Hoa cúc", "Hoa mai", "Hoa đào", "Hoa lan", "0"),
            ("Chữ gì mất đầu là hỏi, mất đuôi trả lời?", "Chữ Tai", "Chữ Mèo", "Chữ Chó", "Chữ Cá", "0"),
            ("Cái gì con người mua để ăn nhưng không bao giờ ăn?", "Bát", "Quần", "Xe hơi", "Nhà", "0"),
            ("Cái gì 2 lỗ: có gió thì sống, không gió thì chết?", "Tai", "Mắt", "Miệng", "Mũi", "3"),
            ("Đồng gì mà đa số ai cũng thích?", "Đồng cỏ", "Đồng tiền", "Đồng hồ", "Đồng phục", "1"),
            ("Cái gì càng cất lại càng thấy?", "Cất xe", "Cất tiền", "Cất nhà", "Cất đồ", "2"),
            ("Chim nào thích dùng ngón tay tác động vật lý?", "Chim cốc", "Chim sẻ", "Chim bồ câu", "Chim gõ kiến", "0"),
            ("Sữa gì khi uống không được đứng yên 1 chỗ?", "Sữa chua", "Sữa bò", "Sữa đậu nành", "Sữa TH", "1"),
            ("Một người năm nay đã 40 tuổi. Hỏi người đó có bao nhiêu ngày sinh nhật?", "365 ngày", "40 ngày", "1 ngày", "14.600 ngày", "2"),
            ("Túi gì nghe tên tưởng ngọt, hoá ra đắng ngắt khó lọt khỏi người?", "Túi đường", "Túi bánh", "Túi kẹo", "Túi mật", "3"),
            ("Trong cuộc sống, con người hay dùng vật này để đánh chính mình, đố là cái gì?", "Lược chải tóc", "Bàn chải đánh răng", "Bàn chải áo quần", "Cây gải ngứa", "1"),
            ("Một xương sống, một đống xương sườn là cái gì?", "Cái lược", "Cái ghế", "Cái bàn", "Cái giường", "0"),
            ("Hồ gì phụ nữ có chồng rất ghét?", "Hồ Gươm", "Hồ Tây", "Hồ ly tinh", "Hồ Ba Bể", "2"),
            ("Cái gì của con chim nhưng lại trên cơ thể con người?", "Vết chân chim", "Vết chim cắn", "Vết chim đậu", "Vết chim đá", "0"),
            ("Con nào ít ai dám ăn, một kẻ lầm lỗi cả bày chịu theo?", "Con chuột", "Con sâu", "Con rắn", "Con dơi", "1"),
            ("Con vật gì là thần nhưng thêm dấu lại thành ác ma?", "Con mèo", "Con chó", "Con rùa", "Con chuột", "2"),
            ("Có cổ nhưng không có miệng là cái gì?", "Cái quần", "Cái mũ", "Cái giày", "Cái áo", "3"),
            ("Sông gì vốn dĩ ồn ào?", "Sông La", "Sông Hồng", "Sông Mê Kông", "Sông Đà", "0"),
            ("Vừa bằng hạt đỗ, ăn giỗ cả làng. Là con gì?", "Con ruồi", "Con mèo", "Con chó", "Con chuột", "0"),
            ("Tôi có 4 cái chân, 1 cái lưng nhưng không có cơ thể. Tôi là ai?", "Cái ghế", "Cái bàn", "Cái giường", "Cái tủ", "1"),
            ("Vì tao tao phải đánh tao, vì tao tao phải đánh mày. Hỏi đang làm gì?", "Đánh muỗi", "Đánh nhau", "Đánh bài", "Đánh đàn", "0"),
            ("Bàn gì xe ngựa sớm chiều giơ ra?", "Bàn ăn", "Bàn cờ tướng", "Bàn học", "Bàn làm việc", "1"),
            ("Bàn gì mà lại bước gần bước xa?", "Bàn tay", "Bàn học","Bàn chân","Bàn ăn", "2"),
            ("Con gì có mũi có lưỡi hẳn hoi. Có sống không chết người đời cầm luôn?", "Con dao", "Cái kéo", "Ngòi bút", "Cái liềm","0"),
            ("Hột để sống: Một tên. Hột nấu lên: tên khác. Trong nhà nông các bác. Đều có mặt cả hai?", "Hột đậu","Hột gạo","Hột mè", "Hột cà phê", "1"),
            ("Da thịt như than. Áo choàng như tuyết. Giúp người trị bệnh. Mà tên chẳng hiền.", "Gà nướng", "Gà rán","Gà ác", "Gà hấp", "2"),
            ("Mặt gì tròn trịa trên cao. Toả ra những ánh nắng đào đẹp thay?", "Mặt trời", "Mặt trăng", "Mặt đất", "Mặt hồ", "0"),
            ("Mặt gì mát dịu đêm nay. Cây đa, chú cuội, đứng đây rõ ràng?", "Mặt trời","Mặt trăng","Mặt đất", "Mặt hồ", "1"),
            ("Mặt gì bằng phẳng thênh thang. Người đi muôn lối dọc ngang phố phường?", "Mặt trời", "Mặt trăng", "Mặt đất", "Mặt hồ", "2"),
            ("Tôi có 4 cái chân, 1 cái lưng nhưng không có cơ thể. Tôi là ai?", "Cái ghế", "Cái giường", "Cái tủ", "Cái bàn", "3"),
            ("Bốn chân đạp đất từ bi, ăn chén sứ hoặc chén sành không ngại. Đó là gì?", "Bàn ăn", "Tủ chén bát", "Ghế", "Cái bàn", "1"),
            ("Ở đỉnh cao nhất trên đầu, không đen như tóc, màu đỏ rực rỡ, lúc khỏe đẹp như mặt trời, khi đau yếu, màu sắc xám dần. Đó là gì?", "Đỉnh núi", "Mũ bảo hiểm", "Mào gà", "Mũ lưỡi trai", "2"),
            ("Cây khô, một lá, bốn năm cành, đường đi uốn khúc, tay anh mệt mỏi, gặp kẻ tiểu nhân, lặng im không nói, chờ người tài giỏi mới được tôn vinh. Đó là gì?", "Cây cầu", "Cây đàn", "Cây cỏ", "Cây bút", "1"),
            ("Lịch nào có thời gian dài nhất?", "Lịch sử", "Lịch âm", "Lịch dương", "Lịch vạn niên", "0"),
            ("Xã nào có số lượng người đông nhất?", "Xã Đông Anh", "Xã hội", "Xã Bắc Sơn", "Xã Nam Trung", "1"),
            ("Con đường nào dài nhất?", "Đường sắt", "Đường phố", "Đường đời", "Đường quốc lộ", "2"),
            ("Quần nào có diện tích rộng nhất?", "Quần jeans", "Quần short", "Quần dài", "Quần đảo", "3"),
            ("Môn thể thao nào càng thắng càng thua?", "Môn đua xe", "Môn bóng đá", "Môn bơi lội", "Môn cầu lông", "0"),
            ("Con gì có đầu dê mà mình là ốc?", "Con chó", "Con dốc", "Con mèo", "Con chuột", "1"),
            ("Con gì sống khi bị đập, chết khi không bị đập?", "Con sâu", "Con tim", "Con chuột", "Con rắn", "1"),
            ("Hạt gì có chiều dài lớn nhất?", "Hạt dẻ", "Hạt đậu", "Hạt mưa", "Hạt gạo", "2"),
            ("Đồ vật nào có thể đi nằm, đứng cũng nằm, nhưng nằm lại đứng?", "Cái bàn", "Cái ghế", "Bàn chân", "Cái giường", "2"),
            ("Khi sở thú bị cháy, con vật nào chạy ra đầu tiên?", "Con hổ", "Con người", "Con sư tử", "Con voi", "1"),
            ("Trên hang đá, dưới hang đá, giữa có con vật gì?", "Miệng", "Con chuột", "Con rắn", "Con dơi", "0"),
            ("Đường nằm ngay thẳng tắp, hai cống hai bên, trên hàng gương, dưới hàng lược. Đó là gì?", "Cái bàn", "Cái ghế", "Mặt", "Cái giường", "2"),
            ("Thân em có nửa là chuột và nửa là chim. Ngày thì treo chân ngủ, tối thì tìm mồi bay. Trời ban tai mắt giỏi thay, tối tăm tối mịt vẫn bay vù vù. Đó là con vật gì?", "Con chim", "Con dơi", "Con chuột", "Con mèo", "1"),
            ("Trong câu: Con đỉa, con rắn, cái ống bơ, ngọn sóng, ngọn gió, con muỗi, con cua, con ốc có bao nhiêu chữ C?", "1", "3", "4", "1", "0"),
            ("Đôi khi đi bằng bốn chân, đôi khi đi bằng hai chân, đôi khi đi bằng ba chân, và đôi khi đi bằng tám chân. Đó là gì?", "Con chó", "Con người", "Con mèo", "Con chuột", "2"),
            ("Đôi khi đi bằng bốn chân, đôi khi đi bằng hai chân, đôi khi đi bằng ba chân, và đôi khi đi bằng tám chân. Đó là gì?", "Con chó", "Con người", "Con mèo", "Con chuột", "2"),
                        

        ]
        for question in defaultQuestions {
            themDL(cauhoi: question.0, dapan1: question.1, dapan2: question.2, dapan3: question.3, dapan4: question.4, dapan: question.5)
        }
    }
    
    
    //Hien thi cau hoi
    func docDL() -> [Question] {
        var questions = [Question]()
            if open() {
                let sql = "SELECT * FROM \(MEAL_TABLE_NAME)"
                do {
                    let results = try database!.executeQuery(sql, values: nil)
                    while results.next() {
                        let id = Int(results.int(forColumn: ID))
                        let cauhoi = results.string(forColumn: NAME) ?? ""
                        let dapan1 = results.string(forColumn: DAPANA) ?? ""
                        let dapan2 = results.string(forColumn: DAPANB) ?? ""
                        let dapan3 = results.string(forColumn: DAPANC) ?? ""
                        let dapan4 = results.string(forColumn: DAPAND) ?? ""
                        let dapan = results.int(forColumn: DAPAN)
                        
                        questions.append(Question.init(id: id, cauhoi: cauhoi, dapan1: dapan1, dapan2: dapan2, dapan3: dapan3, dapan4: dapan4, dapan: Int(dapan)))
                    }
                } catch {
                    os_log("Doc du lieu khong thanh cong")
                }
                close()
            }
            return questions
        }
        // Ham xoa toan bo du lieu trong databse
        func xoaToanBoDL() {
                if open() {
                    let sql = "DELETE FROM \(MEAL_TABLE_NAME)"
                    do {
                        try database!.executeUpdate(sql, values: nil)
                        os_log("Xoa tat ca du lieu thanh cong")
                    } catch {
                        os_log("Xoa tat ca du lieu khong thanh cong")
                    }
                    close()
                }
        }
        // Them nguoi dung vao CSDL
    func themNguoiDung(username: String, count: Int) {
        if open() {
            let sql = "INSERT INTO \(USER_TABLE_NAME) (\(USERNAME), \(COUNT)) VALUES (?, ?)"
            do {
                try database!.executeUpdate(sql, values: [username, count])
                os_log("Them nguoi dung thanh cong")
            } catch {
                os_log("Them nguoi dung khong thanh cong")
            }
            close()
        }
    }
    
    
        // Hien thi thong tin nguoi dung
        func docNguoiDung() -> [User] {
            var users = [User]()
            if open() {
                let sql = "SELECT * FROM \(USER_TABLE_NAME) ORDER BY count DESC"
                do {
                    let results = try database!.executeQuery(sql, values: nil)
                    while results.next() {
                        let user_id = Int(results.int(forColumn: USER_ID))
                        let username = results.string(forColumn: USERNAME) ?? ""
                        let count = Int(results.int(forColumn: COUNT))
                        
                        users.append(User.init(id: user_id, username: username, count: count))
                        
                    }
                } catch {
                    os_log("Doc du lieu nguoi dung khong thanh cong!", error.localizedDescription)
                }
                close()
            }
            return users
        }
        
        // Ham xoa toan bo du lieu nguoi dung trong databse
        func xoaToanBoNguoiDung() {
            if open() {
                let sql = "DELETE FROM \(USER_TABLE_NAME)"
                do {
                    try database!.executeUpdate(sql, values: nil)
                    os_log("Xoa tat ca nguoi dung thanh cong")
                } catch {
                    os_log("Xoa tat ca nguoi dung khong thanh cong")
                }
                close()
            }
        }

}
    


