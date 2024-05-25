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
            //Them cau hoi mac dinh
            //themDLMacDinh()
            //Xoa toan bo du lieu trong databse
            //xoaToanBoDL()
            
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
    private func themDLMacDinh() {
        let defaultQuestions = [
            ("Đuôi thì chẳng thấy, mà có hai đầu?", "Cây cầu", "Con rắn", "Con chó", "Con mèo", "0"),
            ("Cái gì không có chân, không có đuôi, không có cơ thể mà có nhiều đầu?", "Cái bàn", "Cầu truyền hình", "Cái ghế", "Cái xe", "1"),
            ("Ba của Tèo gọi mẹ của Tý là em dâu, vậy ba của Tý gọi ba của Tèo là gì?", "Gọi là em trai", "Gọi là bác", "Gọi là anh trai", "Gọi là chú", "2"),
            ("Phía trước bạn là quảng trường xanh, sau lưng bạn là quảng trường trắng, vậy quảng trường đỏ ở đâu?", "Ở Mỹ", "Ở Trung Quốc", "Ở Nhật Bản", "Ở Nga", "3"),
            ("Vào tháng nào con người sẽ ngủ ít nhất trong năm?", "Tháng 2", "Tháng 1", "Tháng 3", "Tháng 12", "0"),
            ("Loại xe không có bánh thường thấy ở đâu?", "Trên đường", "Trong bàn cờ vua", "Trong nhà", "Trên sân bay", "1"),
            ("Nhà nào lạnh lẽo nhưng ai cũng muốn tới?", "Nhà nghỉ", "Nhà hàng", "Nhà băng", "Nhà sách", "2"),
            ("Hôn mà bị hôn lại gọi là gì?", "Hôn môi", "Hôn má", "Hôn tay", "Đính hôn", "3"),
            ("Tôi chu du khắp thế giới mà tôi vẫn ở nguyên một chỗ, tôi là ai?", "Tem thư", "Người du lịch", "Người lái xe", "Người đi bộ", "0"),
            ("Từ nào trong tiếng Việt có chín mẫu tự h?", "Chính trị", "Chính", "Chính sách", "Chính phủ", "1"),
            ("Bánh gì nghe tên đã thấy sung sướng?", "Bánh Khoái", "Bánh bao", "Bánh mì", "Bánh xèo", "0"),
            ("Bánh gì nghe tên đã thấy đau?", "Bánh bao", "Bánh Tét", "Bánh mì", "Bánh xèo", "1"),
            ("Thứ gì mỗi ngày phải gỡ ra mới có công dụng?", "Đồng hồ", "Máy tính", "Lịch treo tường", "Điện thoại", "2"),
            ("Cái gì luôn chạy không chờ ta bao giờ. Nhưng chúng ta vẫn có thể đứng một chỗ để chờ nó?", "Đồng hồ", "Xe bus", "Xe tăng", "Xe đạp", "0"),
            ("Con gì biết đi nhưng người ta vẫn nói nó không biết đi?", "Con người", "Con bò", "Con mèo", "Con chó", "1"),
            ("Xe nào không bao giờ giảm đi?", "Xe máy", "Xe đạp", "Xe tăng", "Xe bus", "2"),
            ("Cái gì khi xài thì quăng đi, nhưng khi không xài thì lấy lại?", "Mỏ neo", "Điện thoại", "Máy tính", "Đồng hồ", "0"),
            ("Ở đâu 1 con voi có thể ăn 1 cái xe?", "Trong rừng", "Cờ tướng", "Trong sở thú", "Trên đường", "1"),
            ("Cây nhang càng đốt càng ngắn. Vậy cây gì càng đốt nhiều càng dài?", "Cây thông", "Cây cỏ", "Cây tre", "Cây bàng", "2"),
            ("Hạt đường và hạt cát, hạt nào dài hơn?", "Hạt đường", "Hạt cát", "Hạt gạo", "Hạt mè", "0"),
            ("Từ gì bỏ đầu thành tên quốc gia, mất đuôi ra một loài chim?", "Cúc", "Hoa", "Mèo", "Chó", "0"),
            ("Chữ gì mất đầu là hỏi, mất đuôi trả lời?", "Chữ Tai", "Chữ Mèo", "Chữ Chó", "Chữ Cá", "0"),
            ("Cái gì con người mua để ăn nhưng không bao giờ ăn?", "Bát, đũa, dĩa, thìa…", "Quần, áo, mũ, giày...", "Xe hơi, xe máy, xe đạp...", "Nhà, đất, chung cư...", "0"),
            ("Cái gì 2 lỗ: có gió thì sống, không gió thì chết?", "Lỗ tai", "Lỗ mắt", "Lỗ miệng", "Lỗ mũi", "3"),
            ("Đồng gì mà đa số ai cũng thích?", "Đồng cỏ", "Đồng tiền", "Đồng hồ", "Đồng phục", "1"),
            ("Cái gì càng cất lại càng thấy?", "Cất xe", "Cất tiền", "Cất nhà", "Cất đồ", "2"),
            ("Chim nào thích dùng ngón tay tác động vật lý?", "Chim cốc", "Chim sẻ", "Chim bồ câu", "Chim chích chòe", "0"),
            ("Sữa gì khi uống không được đứng yên 1 chỗ?", "Sữa chua", "Sữa lắc", "Sữa đậu nành", "Sữa bò", "1"),
            ("Một người năm nay đã 40 tuổi. Hỏi người đó có bao nhiêu ngày sinh nhật?", "365 ngày", "40 ngày", "1 ngày", "14.600 ngày", "2"),
            ("Túi gì nghe tên tưởng ngọt, hoá ra đắng ngắt khó lọt khỏi người?", "Túi xách", "Túi nilon", "Túi giấy", "Túi mật", "3"),
            ("Trong cuộc sống, con người hay dùng vật này để đánh chính mình, đố là cái gì?", "Bàn chải tóc", "Bàn chải đánh răng", "Bàn chải quét nhà", "Bàn chải rửa bát", "1"),
            ("Một xương sống, một đống xương sườn là cái gì?", "Cái lược", "Cái ghế", "Cái bàn", "Cái giường", "0"),
            ("Hồ gì phụ nữ có chồng rất ghét?", "Hồ Gươm", "Hồ Tây", "Hồ ly tinh", "Hồ Ba Bể", "2"),
            ("Cái gì của con chim nhưng lại trên cơ thể con người?", "Vết chân chim", "Vết cắn chim", "Vết đậu chim", "Vết đá chim", "0"),
            ("Con nào ít ai dám ăn, một kẻ lầm lỗi cả bày chịu theo?", "Con chuột", "Con sâu", "Con rắn", "Con dơi", "1"),
            ("Con vật gì là thần nhưng thêm dấu lại thành ác ma?", "Con mèo", "Con chó", "Con rùa", "Con chuột", "2"),
            ("Có cổ nhưng không có miệng là cái gì?", "Cái quần", "Cái mũ", "Cái giày", "Cái áo", "3"),
            ("Sông gì vốn dĩ ồn ào?", "Sông La", "Sông Hồng", "Sông Mê Kông", "Sông Đà", "0"),
            ("Vừa bằng hạt đỗ, ăn giỗ cả làng. Là con gì?", "Con ruồi", "Con mèo", "Con chó", "Con chuột", "0"),
            ("Tôi có 4 cái chân, 1 cái lưng nhưng không có cơ thể. Tôi là ai?", "Cái ghế", "Cái bàn", "Cái giường", "Cái tủ", "1"),
            ("Vì tao tao phải đánh tao, vì tao tao phải đánh mày. Hỏi đang làm gì?", "Đập muỗi", "Đánh nhau", "Đánh bài", "Đánh đàn", "0"),
            ("Bàn gì xe ngựa sớm chiều giơ ra?", "Bàn ăn", "Bàn cờ tướng", "Bàn học", "Bàn làm việc", "1"),
            ("Bàn gì mà lại bước gần bước xa?", "Bàn tay", "Bàn học","Bàn chân","Bàn ăn", "2"),
            ("Con gì có mũi có lưỡi hẳn hoi. Có sống không chết người đời cầm luôn?", "Con dao", "Con kéo", "Con bút", "Chiếc chìa khóa","0"),
            ("Hột để sống: Một tên. Hột nấu lên: tên khác. Trong nhà nông các bác. Đều có mặt cả hai?", "Hột đậu","Hột gạo","Hột mè", "Hột cà phê", "1"),
            ("Da thịt như than. Áo choàng như tuyết. Giúp người trị bệnh. Mà tên chẳng hiền.", "Gà nướng", "Gà rán","Gà ác", "Gà hấp", "2"),
            ("Mặt gì tròn trịa trên cao. Toả ra những ánh nắng đào đẹp thay?", "Mặt trời", "Mặt trăng", "Mặt đất", "Mặt hồ", "0"),
            ("Mặt gì mát dịu đêm nay. Cây đa, chú cuội, đứng đây rõ ràng?", "Mặt trời","Mặt trăng","Mặt đất", "Mặt hồ", "1"),
            ("Mặt gì bằng phẳng thênh thang. Người đi muôn lối dọc ngang phố phường?", "Mặt trời", "Mặt trăng", "Mặt đất", "Mặt hồ", "2"),
            ("Tôi có 4 cái chân, 1 cái lưng nhưng không có cơ thể. Tôi là ai?", "Cái ghế", "Cái giường", "Cái tủ", "Cái bàn", "3"),
            ("Bốn chân đạp đất từ bi, ăn chén sứ hoặc chén sành không ngại. Đó là gì?", "Bàn ăn", "Tủ chén bát", "Ghế", "Cái bàn", "1"),
            ("Ở đỉnh cao nhất trên đầu, không đen như tóc, màu đỏ rực rỡ, lúc khỏe đẹp như mặt trời, khi đau yếu, màu sắc xám dần. Đó là gì?", "Đỉnh núi", "Mũ bảo hiểm", "Mào của con gà trống", "Mũ lưỡi trai", "2"),
            ("Cây khô, một lá, bốn năm cành, đường đi uốn khúc, tay anh mệt mỏi, gặp kẻ tiểu nhân, lặng im không nói, chờ người tài giỏi mới được tôn vinh. Đó là gì?", "Cây cầu", "Cây đàn", "Cây cỏ", "Cây bút", "1"),
            ("Lịch nào có thời gian dài nhất?", "Lịch sử", "Lịch âm", "Lịch dương", "Lịch vạn niên", "0"),
            ("Xã nào có số lượng người đông nhất?", "Xã Đông Anh", "Xã hội", "Xã Bắc Sơn", "Xã Nam Trung", "1"),
            ("Con đường nào dài nhất?", "Đường sắt", "Đường phố", "Đường đời", "Đường quốc lộ", "2"),
            ("Quần áo nào có diện tích rộng nhất?", "Quần jeans", "Quần short", "Quần dài", "Quần đảo", "3"),
            ("Môn thể thao nào càng thắng càng thua?", "Môn đua xe", "Môn bóng đá", "Môn bơi lội", "Môn cầu lông", "0"),
            ("Con gì có đầu dê mà mình là ốc?", "Con chó", "Con dốc", "Con mèo", "Con chuột", "1"),
            ("Con gì sống khi bị đập, chết khi không bị đập?", "Con trùng", "Con tim", "Con chuột", "Con rắn", "1"),
            ("Hạt gì có chiều dài lớn nhất?", "Hạt dẻ", "Hạt đậu", "Hạt mưa", "Hạt gạo", "2"),
            ("Đồ vật nào có thể đi nằm, đứng cũng nằm, nhưng nằm lại đứng?", "Cái bàn", "Cái ghế", "Bàn chân", "Cái giường", "2"),
            ("Khi sở thú bị cháy, con vật nào chạy ra đầu tiên?", "Con hổ", "Con người", "Con sư tử", "Con voi", "1"),
            ("Trên hang đá, dưới hang đá, giữa có con vật gì?", "Cái miệng", "Con chuột", "Con rắn", "Con dơi", "0"),
            ("Đường nằm ngay thẳng tắp, hai cống hai bên, trên hàng gương, dưới hàng lược. Đó là gì?", "Cái bàn", "Cái ghế", "Bộ mặt", "Cái giường", "2"),
            ("Thân em có nửa là chuột và nửa là chim. Ngày thì treo chân ngủ, tối thì tìm mồi bay. Trời ban tai mắt giỏi thay, tối tăm tối mịt vẫn bay vù vù. Đó là con vật gì?", "Con chim", "Con dơi", "Con chuột", "Con mèo", "1"),
            ("Có tám thứ được đề cập trong câu 37. Đó là gì?", "Con đỉa, con rắn, cái ống bơ, ngọn sóng, ngọn gió, con muỗi, con cua, con ốc", "Con chuột, con mèo, con chó, con gà, con vịt, con heo, con bò, con cừu", "Con hổ, con sư tử, con voi, con khỉ, con cừu, con dê, con ngựa, con lợn", "Con chim, con cánh cụt, con đại bàng, con chim cánh cụt, con chim sẻ, con chim hải âu, con chim bồ câu, con chim cánh cụt", "0"),
            ("Đôi khi đi bằng bốn chân, đôi khi đi bằng hai chân, đôi khi đi bằng ba chân, và đôi khi đi bằng tám chân. Đó là gì?", "Con chó", "Con người", "Con mèo", "Con chuột", "2"),
            ("Đồ vật nào có kích thước bằng một thước nhưng không thể vượt qua?", "Cái bàn", "Cái bóng", "Cái ghế", "Cái giường", "1"),
            ("Hai cô nằm nghỉ hai phòng. Ngày thì mở cửa ra trông, đêm thì đóng cửa lấp trong ra ngoài. Đó là gì?", "Đôi mắt", "Cái cửa", "Cái bàn", "Cái ghế", "0"),
            ("Chân đỏ mình đen. Đầu đội hoa sen. Lên chầu Thượng đế. Là gì?", "Cây đào", "Cây mai", "Cây lý", "Cây hương nhang", "3"),
            ("Một vật không có cành hay cội, chỉ có một lá. Ta có thể trao tay. Là gì?", "Lá cây", "Lá bài", "Lá sen", "Lá dứa", "1"),
            ("Một vật đi thì ăn trước, ngồi trên. Về thì lấm lét đứng bên xó hè. Là gì?", "Cái ghế", "Cái bàn", "Cái giường", "Cái thảm", "0"),
            ("Một vật có hình dạng vuông vắn, có tay ngắn và chân dài. Trèo qua hai hòn động thiên thai và ôm lấy nàng tiên nữ. Là gì?", "Cái cầu", "Cái thang", "Cái còng số 8", "Cái cầu thang", "2"),
            ("Một vật có thân làm từ đồng, da bọc sắt. Có hai con mắt ở trên lưng và cái chân ở giữa bụng. Là gì?", "Con ốc nhồi", "Con ốc sên", "Con ốc mượn hồn", "Con ốc đảo", "1"),
            ("Một vật có ruột chấm vừng đen, khi ăn vào mát và bổ. Là gì?", "Quả dứa", "Quả dừa", "Quả xoài", "Quả mít", "0"),
            ("Một vật có chân nhưng không biết đi. Quanh năm suốt tháng đứng ở một nơi. Là gì?", "Cái ghế", "Cái giường", "Cái bàn", "Cái thảm", "2"),
            ("Một cây nhỏ nhắn, hạt nó nuôi người. Chín vàng nơi nơi, dân làng đi hái. Là gì?","Cây mía", "Cây lúa", "Cây ngo", "Cây khoai","1"),
            ("Một vật có thân nhỏ, đi khắp nơi để giúp người. Hiến trọn tấm thân cho người, không chê chuộng và không quản công. Là gì?","Cây bút", "Cây cọ", "Cây thông", "Chổi lông gà","0"),("Mồm bò mà không phải mồm bò. Đố là con gì?","Con bò", "Con ốc sên", "Con mèo", "Con chó","1"),
            ("Mình bằng con sâu, Nhà ba căn hai chái, thò đầu thò đuôi. Là gì?","Đèn dầu", "Con ốc sên", "Con rắn", "Con chó","0"),
            ("Chân đạp miền thanh địa, Đầu đội mũ bình thiên, Mình thì bận áo mã tiên, Ban ngày đôi ba vợ, tối nằm riêng kêu trời. Là gì?","Con ốc sên", "Gà trống", "Con rắn", "Con chó","1"),
            ("Trên đầu đội sắc vua ban, Dưới thời yếm thắm, dây vàng xum xoe, Thần linh đã gọi thì về, Ngồi trên mâm ngọc, gươm kề sau lưng. Là gì?","Con ốc sên", "Gà trống cúng", "Con rắn", "Con chó","1"),
            ("Một mẹ đẻ được bọc con, Đứa nào đứa nấy đầu tròn như nhau, Xót thương số phận thương đau, Nên chúng lần lượt đập đầu ra đi. Là gì?","Con ốc sên", "Bao diêm", "Con rắn", "Con chó","1"),
            ("Cái gì không có trống, chỉ có mái, Cả đời chỉ đái, không biết ị. Là gì?","Con ốc sên", "Con rắn", "Mái nhà", "Con chó","2"),
            ("Cái gì của ta, Chặt không đứt, dứt không ra? Là cái gì?","Cái bóng", "Con ốc sên", "Con rắn", "Con chó","0"),
            ("Đem thân che nắng cho đời, Rồi ra mang tiếng là người chả khôn? Là gì?","Con ốc sên", "Con rắn", "Mành che cửa", "Con chó","2"),
            ("Lá gì ăn sống thì lành, nấu canh thì độc? Là lá gì?","Lá trầu", "Lá sen", "Lá dứa", "Lá lốt","0"),
            ("Mẹ vuông, con tròn, Mỗi lứa sòn sòn, Đẻ 20 đứa. Là gì?","Bao thuốc lá", "Hộp quẹt", "Bao diêm", "Hộp diêm","0"),
            ("Chữ gì: Tai nghe, miệng nói, đít làm vua. Là chữ gì?","Chữ Tâm", "Chữ Thánh", "Chữ Tình", "Chữ Từ","1"),
            ("Đầu đen như quạ, Dạ trắng như bông, Lưng thắt cổ bồng, Đít mang lọ nước. Là cái gì?","Cái đèn pin", "Cái đèn dầu", "Cái đèn sưởi", "Cái đèn tròn","1"),
            ("Mình vàng mà thắt đai vàng một mình dọn dẹp sửa sang trong nhà. Là cái gì?","Cái chổi", "Cái cây lau nhà", "Cái cây quét nhà", "Cái cây lau bụi","0"),
            ("Có sống mà chẳng có lưng, Có lưỡi có mũi mà không có mồm. Là cái gì?","Cái kéo", "Cái búa", "Cái dao", "Cái cưa","2"),
            ("Hai con mà ở hai phòng, Ngày thì mở cửa ra trông, Đêm thì đóng cửa lấp chông ra ngoài. Là gì?","Con tai", "Con mắt", "Con mũi", "Con miệng","2"),
            ("Lưng trước bụng sau, Con mắt ở dưới cái đầu ở trên. Là cái gì?","Cái chân", "Cái tay", "Cái đầu", "Cái mặt","0"),
            ("Năm ông cầm hai cái sào, Lùa đàn cò trắng chạy vào trong hang. Là gì?","Ăn phở", "Ăn cơm", "Ăn bún", "Ăn mì","1"),
            ("Tên em không thiếu không thừa, Tấm lòng vàng ngọt, ngon vừa lòng anh. Quả gì nói nhanh? Là gì?","Quả đu đủ", "Quả dưa hấu", "Quả táo", "Quả cam","0"),
            ("Thuở bé em có 2 sừng, Đến tuổi nửa chừng mặt đẹp như hoa, Ngoài hai mươi tuổi về già, Quá ba mươi lại mọc ra hai sừng. Là gì?","Mặt trời", "Mặt trăng", "Sao Hỏa", "Sao Thổ","1"),
            ("Vừa bằng cái vung, Vùng xuống ao, Đào chẳng thấy, Lấy chẳng được. Là gì?","Bóng cây, bóng người", "Bóng mặt trăng", "Bóng đèn, bóng đá", "Bóng bàn, bóng chày", "1"),
            ("Mèo tam thể lai mèo tam thể thì ra con gì. Là con gì?","Mèo tam thể đẻ được", "Mèo tam thể đẻ mèo bốn thể", "Mèo tam thể không đẻ được", "Mèo tam thể đẻ mèo hai thể","2"),
            ("Cây chi nhánh sắt, cội ngà. Đố chàng nho sĩ biết là cây chi? Là cây gì?","Cây bàng", "Cây dừa", "Cây chuối", "Cây ô","3"),
            ("Con chi không ăn, không nói, không cười, Nghiêng lưng mà chịu với người hôm mai. Là con gì?","Con đà lót ván, sập ngựa", "Con mèo, con chó", "Con chuột, con nhện", "Con rắn, con ốc","0"),
            ("Ở nhà có một bà ăn cơm hớt. Là gì?","Cái thìa", "Ðôi đũa cả", "Cái nĩa", "Cái muỗng","1"),
            ("Ở nhà có bà hay liếm. Là cái gì?","Cái cây lau nhà", "Cái chổi", "Cái cây quét nhà", "Cái cây lau bụi", "1"),
            ("Loẹt quẹt như đuôi gà thiến, Liến thiến như ngọn thối lai, Chúa mất tôi ngơ ngẩn kiếm hoài, Tôi mất chúa nằm im lẳng lặng. Là cái gì?","Cái chổi", "Cái cây lau nhà", "Cái cây quét nhà", "Cái cây lau bụi","0"),
            ("Cổ cao cao, cẳng cao cao, Chân đen cánh trắng ra vào đồng xanh, Cảnh quê thêm đẹp bức tranh, Sao đành chịu tiếng ma lanh nhử mồi. Là con gì?","Con cò", "Con vịt", "Con gà", "Con vịt","0"),
            ("Bốn cây cột đình, Hai đinh nhọn hoắt, Hai cái lúc lắc, Một cái tòng teng, Trùng trục da đen, Lại ưa đầm vũng? Là con gì?","Con bò", "Con ngựa", "Con trâu", "Con lừa","2"),
            ("Mình bằng hạt gạo, Mỏ bằng hạt kê, Hỏi đi đâu về? Đi làm thợ mộc. Là con gì?","Con mọt", "Con chuột", "Con kiến", "Con gián","0"),
            ("Cái đuôi hết ngắn lại dài, Tiếc chi cứ chắc lưỡi hoài vách phên, Tên thường tên chữ, hai tên, Đố bốn phía, đố ba bên tên gì? Là con gì?","Con thằn lằn, con rắn", "Con thằn lằn, con thạch sùng", "Con thằn lằn, con giun", "Con thằn lằn, con sâu","1"),
            ("Củ gì da cam, Thịt lại giòn giòn, Ăn thì ngon lắm, Lại sáng mắt cơ? Là củ gì?","Củ cải", "Củ hành", "Củ cà rốt", "Củ tỏi","2"),
            ("Củ tròn như cái bát, Áo màu xanh non, Quanh thân có lá, Xào nấu rất ngon, Tên như tiêu được, Đố bạn củ gì?","Củ cải", "Củ hành", "Củ su hào", "Củ tỏi","2"),
            ("Thân em vừa trắng lại vừa tròn, Bảy nổi ba chìm với nước non, Rắn nát mắc dầu tay kẻ nặn, Mà em vẫn giữ tấm lòng son. Là gì?","Bánh bao", "Bánh trôi nước", "Bánh mì", "Bánh cuốn","1"),
            ("Thân dài thượt, Ruột thẳng băng, Khi thịt bị cắt khỏi chân, Thì ruột lòi dần vẫn thẳng như rươi? Là cái gì?","Cái bút chì", "Cái bút mực", "Cái bút bi", "Cái bút lông","0"),
            ("Đầu đuôi vuông vắn như nhau, Thân chia nhiều đốt rất mau rất đều, Tính tình chân thức đáng yêu, Muốn biết dài ngắn mọi điều có em? Là cái gì?","Cái thước đo", "Cái thước kẻ", "Cái thước thợ", "Cái thước thủy","1"),
            ("Cày trên đồng ruộng trắng phau, Khát xuống uống nước giếng sâu đen ngòm? Là cái gì?","Cái bút mực", "Cái bút chì", "Cái bút bi", "Cái bút lông","0"),

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
                        os_log("Xóa tất cả dữ liệu thành công")
                    } catch {
                        os_log("Xóa tất cả dữ liệu không thành công: %@", error.localizedDescription)
                    }
                    close()
                }
            }
}

