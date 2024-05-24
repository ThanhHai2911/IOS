//
//  GameViewController.swift
//  DoVui
//
//  Created by DoTruongThanh on 16/05/2024.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var AnswerA: UIButton!
    @IBOutlet weak var AnswerB: UIButton!
    @IBOutlet weak var AnswerC: UIButton!
    @IBOutlet weak var AnswerD: UIButton!
    @IBOutlet weak var thonBao: UILabel!
    @IBOutlet weak var NextQuestion: UIButton!
    
    @IBOutlet weak var Time: UILabel!
    
    @IBOutlet weak var Count: UILabel!
    
    var questions: [Question] = []
       
    //Dinh nghia doi tuong truy xuat CSDL
    private let db = Database()
    
    var time: Timer?
    //Thoi gian dem nguoc
    var timeCount = 10
    //giá trị của mảng để lấy câu hỏi -> random
    var questionNowIndex = 0
    // điểm
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Lấy dữ liệu từ json
        if let loadedQuestions = Question.loadQuestions(from: "question") {
                  questions = loadedQuestions
              } else {
                  print("Khong the loat cau hoi")
              }
        //goi ham
         displayQuestion()
        startTime()
        
    }
    
    //Ham dem nguoc thoi gian
    @objc func timeOut(){
    
        timeCount = timeCount - 1
        Time.text = String(timeCount)
        if timeCount <= 0{
            time?.invalidate()
            time = nil
            
            // Thay the bang tu dong chuyen cau
            print("Hết thời gian trả lời")
            
            
            //Sau khi het thoi gian se chuyen den man hinh thong tin va hien thi so diem
            let vc = storyboard?.instantiateViewController(identifier: "thongtin") as! ThongTinController
            vc.modalPresentationStyle = .fullScreen
            vc.receivedCount = count //Lay thong tin diem qua man hinh thong tin
            vc.notificationMessage = "Hết thời gian trả lời câu hỏi!" //Dua thong bao qua man hinh thong tin
            present(vc, animated: true)
        }
        
    }
    	
    
    // Xuat ra Man Hinh du lieu
    func displayQuestion(){
        let correntQuestion = questions[questionNowIndex]
        QuestionLabel.text = correntQuestion.questionName
        let btnAnswers = [AnswerA,AnswerB,AnswerC,AnswerD]
        for (index, button) in btnAnswers.enumerated() {
            button?.setTitle(correntQuestion.answers[index], for: .normal)
            button?.tag = index
            button?.backgroundColor = UIColor.clear
            button?.isEnabled = true
        }
            Count.text = String(count)
            Time.text = String(timeCount)
}
    //Ham khoi chay thoi gian
    func startTime(){
        time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeOut), userInfo: nil, repeats: true)
    }
    //Ham dung dem thoi gian
    func stopTime(){
        time?.invalidate()
        time = nil
    }
    
    
    // Ham random
    func ramDom()->Int{
        var randomIndex: Int
        // Chọn ngẫu nhiên câu hỏi mảng questions
        randomIndex = Int(arc4random_uniform(UInt32(questions.count)))
     
        return randomIndex

 }
    
    
    func ramDomCauHoi(){
        
        questionNowIndex = ramDom()
        
        print("index_CauHoi \(questionNowIndex)");
        let correntQuestion = questions[questionNowIndex]
        QuestionLabel.text = correntQuestion.questionName
        let btnAnswers = [AnswerA,AnswerB,AnswerC,AnswerD]
        for (index, button) in btnAnswers.enumerated() {
            button?.setTitle(correntQuestion.answers[index], for: .normal)
            button?.tag = index
            button?.backgroundColor = UIColor.clear
            button?.isEnabled = true
        }
            Count.text = String(count)
            Time.text = String(timeCount)
        

}
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let selectedAnswerIndex = sender.tag
        let correct = questions[questionNowIndex].correct
        let btnAnswers = [AnswerA, AnswerB, AnswerC, AnswerD]
        stopTime()
        // Tắt tất cả các button
                for button in btnAnswers {
                           button?.isEnabled = false
                       }
        if selectedAnswerIndex == correct{
            count += 10
           print("Bạn đã trả lời đúngg!")
            thonBao.text = "Bạn đã trả lời đúngg!"
            // xoa thong bao
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.thonBao.text = ""
                    }
            ramDomCauHoi()
                    timeCount = 30
                    if(questionNowIndex < questions.count){
                        displayQuestion()
                        startTime()
                    }
           } else {
               if count == 0{
                   count = 0
                   //Tra loi sai cau dau se chuyen den man hinh thong tin va hien thi so diem
                   let vc = storyboard?.instantiateViewController(identifier: "thongtin") as! ThongTinController
                   vc.modalPresentationStyle = .fullScreen
                   vc.receivedCount = count //Lay thong tin diem qua man hinh thong tin
                   vc.notificationMessage = "Bạn đã trả lời sai!" //Dua thong bao qua man hinh thong tin
                   present(vc, animated: true)
               }else{
                   count -= 10
                   //Sau khi tra loi sai se chuyen den man hinh thong tin va hien thi so diem
                   let vc = storyboard?.instantiateViewController(identifier: "thongtin") as! ThongTinController
                   vc.modalPresentationStyle = .fullScreen
                   vc.receivedCount = count //Lay thong tin diem qua man hinh thong tin
                   vc.notificationMessage = "Bạn đã trả lời sai!" //Dua thong bao qua man hinh thong tin
                   present(vc, animated: true)
               }
               stopTime()
           }
        Count.text = String(count)
        
       }


}


