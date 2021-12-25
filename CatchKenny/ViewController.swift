//
//  ViewController.swift
//  CatchKenny
//
//  Created by Mac on 25.12.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var kennyImageView: UIImageView!
    @IBOutlet weak var HiggestScoreLabel: UILabel!
    @IBOutlet weak var kennyView: UIView!
    
    var timer = Timer()
    var timerImageView = Timer()
    var count = 0
    var score = 0
//    var kennyViewWidth: CGFloat = 0.0
//    var kennyViewHeight: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // for image interaction
        kennyImageView.isUserInteractionEnabled=true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(picClicked))
        kennyImageView.addGestureRecognizer(gestureRecognizer)
        // kennyImageView embeded view position;
//        kennyViewWidth = kennyView.frame.size.width
//        kennyViewHeight = kennyView.frame.size.height
        checkSaveability()
        startTimer()
        startTimerForImageView()
    }
    
    @objc func runTimerFunc(){
        count -= 1
        timeLabel.text = "Time: \(count)"
        if count == 0 {
            timer.invalidate()
            timerImageView.invalidate()
            timeLabel.text = "Time is over!"
            //Check if UserDefaults has smaller score value than right now
            checkSaveability()
            //show alert retry
            alertFunct()
        }
    }
    @objc func picClicked(){
        score += 1
        scoreLabel.text = "Score: \(score)"
      }
    func alertFunct(){
        let alert = UIAlertController(title: "Time is over!", message: "", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    //print("button clicked")
                }
        let reTryButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.startTimer()
            self.startTimerForImageView()
                }
        alert.addAction(okButton)
        alert.addAction(reTryButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startTimer(){
        count = 10
        score = 0
        scoreLabel.text = "Score: \(score)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimerFunc), userInfo: nil, repeats: true)
    }
    func startTimerForImageView(){
       
        timerImageView = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(runTimerFuncForImageView), userInfo: nil, repeats: true)
    }
    @objc func runTimerFuncForImageView(){
       //change imageView kenny position in its embeded view
        let maxX = Int(kennyView.frame.maxX - kennyImageView.frame.size.width)
        let maxY = Int(kennyView.frame.maxY - kennyImageView.frame.size.height)
        let xPoz =  CGFloat(Int.random(in: 0...maxX))
        let yPoz =  CGFloat(Int.random(in: 0...maxY))
        kennyImageView.frame = CGRect(x: xPoz, y: yPoz, width: kennyImageView.frame.size.width, height: kennyImageView.frame.size.height)
        //kennyView.addSubview(kennyImageView)
    }
    
    func checkSaveability(){
        if let data = UserDefaults.standard.object(forKey: "scoreSaved"){
            if let dataInt = data as? Int {
                if dataInt < score {
                    UserDefaults.standard.set(score, forKey: "scoreSaved")
                    HiggestScoreLabel.text = "Higgest Score: \(score)"
                }else {
                    HiggestScoreLabel.text = "Higgest Score: \(dataInt)"
                }
            }
        }else {
            UserDefaults.standard.set(score, forKey: "scoreSaved")
        }
    }
}

