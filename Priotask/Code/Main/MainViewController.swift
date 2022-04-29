//
//  MainViewController.swift
//  Priotask
//
//  Created by Nikita Felicia on 27/04/22.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var timerStartButton: UIButton!

    @IBOutlet weak var timerTimeLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!

    @IBOutlet weak var timerButton: UIButton!

    @IBOutlet weak var timeTextField: UITextField!

    let timerTrackLayer = CAShapeLayer()
    let timerCircleFillLayer = CAShapeLayer()
    let timerRoundLayer = CAShapeLayer()
    
    let easeInAnimation = Animations.easeInBackgroundColor
    let blinkAnimation = Animations.blinkReverse
    let easeOpacity = Animations.easeInOpacity
    
   // let notificationCenter = UNUserNotificationCenter.current()
    
    var timerStarted = false
    
    var timerSecondsSelected = 0
    
    var timerSecondCount = 0
    var timerMiniSecondCount = 0
    
    var initialValue: CGFloat = 0.7
    var microSeconds = 0
    
    var countdownTimer = Timer()
    var countdownPickerTimer = Timer()
    
    var featureSelected = 0
    let buttonPadding: CGFloat = 35.0
    
    var trackColor = UIColor.gray.withAlphaComponent(0.5)
    var trackFillColor = UIColor(named: "purpleAccent")!
    var trackLeadColor = UIColor.label

    lazy var countdownPicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .countDownTimer
        date.countDownDuration = 59
        date.addTarget(self, action: #selector(MainViewController.valueChanged(datePicker:)), for: .valueChanged)
        
        return date
    }()
    
    lazy var strokeStartAnimation: CABasicAnimation = {
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.duration = 60
        strokeStart.toValue = 1
        strokeStart.fillMode = .forwards
        return strokeStart
    }()
    
    lazy var strokeEndAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.duration = 60
        strokeEnd.toValue = 1
        strokeEnd.fillMode = .forwards
        return strokeEnd
    }()
    
    lazy var timerEndAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.duration = 120
        strokeEnd.toValue = 0
        strokeEnd.fillMode = .forwards
        return strokeEnd
    }()
    
    lazy var timerStartAnimation: CABasicAnimation = {
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.duration = 120
        strokeStart.toValue = 0
        strokeStart.fillMode = .forwards
        return strokeStart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeTextField.inputView = countdownPicker
        let radius: CGFloat = self.view.frame.height > 735 ? 150 : 140
        
        var arcPath = UIBezierPath(arcCenter: self.timerContainerView.center, radius: radius, startAngle: 0, endAngle: 360.degreeToRadians(), clockwise: true)
        
        arcPath = UIBezierPath(arcCenter: CGPoint(x: timerView.frame.origin.x + (timerView.frame.width / 2) - 24, y: timerView.frame.origin.y - (timerView.frame.height / 2)), radius: 140, startAngle: 0, endAngle: 360.degreeToRadians(), clockwise: true)
        
        timerTrackLayer.setTrackLayer(arcPath: arcPath, trackColor: trackColor)
        timerCircleFillLayer.setFillLayerProperties(arcPath: arcPath, trackColor: trackFillColor, isTimer: true)
        timerRoundLayer.setRoundFillerLayer(arcPath: arcPath, trackColor: trackLeadColor, strokeStart: 1 - 0.004, strokeEnd: 1)
        
        timerView.layer.addSublayer(timerTrackLayer)
        timerView.layer.addSublayer(timerCircleFillLayer)
        timerView.layer.addSublayer(timerRoundLayer)
        
        setupViews()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
        }

        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
 
        timerCircleFillLayer.fillColor = UIColor(named: "background")?.cgColor
        self.trackLeadColor = UIColor.label

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func valueChanged(datePicker: UIDatePicker) {
        let seconds = datePicker.countDownDuration.toInt()
        let minutes = (seconds / 60) % 60
        let hours = seconds / 3600
        
        self.timerSecondCount = seconds
        self.timeTextField.text = "\(hours.appendZeros()):\(minutes.appendZeros())"
    }
    
    @objc func finishTime() {
        self.countdownPickerTimer.invalidate()
        self.timeTextField.resignFirstResponder()
    }
    
    @objc func cancelPicker(){
        self.timeTextField.resignFirstResponder()
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        
        if (!timerStarted) {
            self.countdownPickerTimer.invalidate()
            self.timerStartAnimation.duration = Double(self.timerSecondCount) + 1
            self.timerEndAnimation.duration = Double(self.timerSecondCount) + 1
            
            self.timerStartButton.setTitle("Stop", for: .normal)
            easeInAnimation.animateView(view: timerStartButton, color: UIColor(named: "purpleAccent")!)
        
            self.timeTextField.isUserInteractionEnabled = false
            
            self.timerMiniSecondCount = 60
            
            let seconds = self.timerSecondCount
            var minutes = (seconds / 60) % 60
            let hours = seconds / 3600
            self.timerSecondCount -= 1
            
            self.timerTimeLabel.text = "00:\(minutes.appendZeros()):00"
            
            easeOpacity.animateView(view: timerView)
            self.timeTextField.layer.opacity = 0
            self.hintLabel.layer.opacity = 0
            
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
                
                self.timerSecondCount -= 1
                self.timerMiniSecondCount -= 1
                if (self.timerMiniSecondCount == -1) {
                    self.timerMiniSecondCount = 0
                }
                if (minutes - 1 >= 0) {
                    self.timerTimeLabel.text = "\(hours.appendZeros()):\((minutes - 1).appendZeros()):\(self.timerMiniSecondCount.appendZeros())"
                } else {
                    self.timerTimeLabel.text = "\(hours.appendZeros()):\(minutes.appendZeros()):\(self.timerMiniSecondCount.appendZeros())"
                }
                
                if (self.timerSecondCount < -1) {
                    self.timerTimeLabel.text = "00:00:00"
                    self.countdownTimer.invalidate()
                    self.easeOpacity.animateView(view: self.finishedLabel)
                    self.blinkAnimation.animateView(view: self.timerTimeLabel)
                    self.resetTimer()
                    self.notify()
                }
                
                if (self.timerMiniSecondCount <= 0) {
                    self.timerMiniSecondCount = 60
                    if (minutes > 0) {
                        minutes -= 1
                    }
                }
            })
            self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
            self.timerRoundLayer.add(self.timerStartAnimation, forKey: "timerRoundStart")
            self.timerRoundLayer.add(self.timerEndAnimation, forKey: "timerRoundEnd")
        } else {
            self.resetTimer()
            self.timerTimeLabel.text = "00:00:00"
            countdownPickerTimer =  Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { (Timer) in
                self.countdownPicker.sendActions(for: .valueChanged)
            }
        }
        self.timerStarted = !self.timerStarted
        
    }
    
    @IBAction func featureButtonChanged(_ sender: Any) {
        let selectedButton = sender as! UIButton
        
        if (selectedButton.tag != featureSelected){
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                self.timerButton.tintColor = UIColor(named: "purpleUnselected")
                self.timerButton.layer.opacity = 0.8
            })
            if selectedButton.tag == 0 {
              
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.toggleView(initial: true)
                  //  self.Notify(initial: true)
                    
                })
            } else {
                self.timerButton.tintColor = UIColor(named: "purpleAccent")
                self.timerButton.layer.opacity = 1.0
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.toggleView(initial: false)
                   // self.Notify(initial: false)

                })
            }
        }
        featureSelected = selectedButton.tag
    }
    
    func setupViews(){
        let toolbar = UIToolbar()
        toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toolbar.tintColor = UIColor(named: "purpleAccent")
        
        let cancelBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        let doneBarItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishTime))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelBarItem, spacer, doneBarItem], animated: false)
        
        self.timeTextField.inputAccessoryView = toolbar
        
        self.timerView.bringSubviewToFront(timerContainerView)
        self.timerView.bringSubviewToFront(finishedLabel)
        self.timerContainerView.transform = self.timerContainerView.transform.rotated(by: 90.degreeToRadians())
        
        timerView.backgroundColor = UIColor.systemBackground
        timerView.transform = timerView.transform.rotated(by: 270.degreeToRadians())
        
        timerStartButton.layer.cornerRadius = 12
        timerStartButton.backgroundColor = UIColor(named: "purpleAccent")
        
        self.toggleView(initial: true)
        countdownPicker.countDownDuration = 0
        
    }
    
    func resetTimer(){
        self.countdownTimer.invalidate()
        self.timeTextField.layer.opacity = 1
        self.timerStartButton.setTitle("Start", for: .normal)
        self.timeTextField.isUserInteractionEnabled = true
        easeInAnimation.animateView(view: timerStartButton, color: UIColor(named: "purpleAccent")!)
        
        timerRoundLayer.strokeStart = 1 - 0.004
        timerRoundLayer.strokeEnd = 1
        self.timerCircleFillLayer.removeAllAnimations()
        self.timerRoundLayer.removeAllAnimations()
    }
    
    func notify(){
        let content = UNMutableNotificationContent().self
        content.title = "Time is up! Continue to your next work"
        content.body = "Timer is completed successfully in background!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
        
    }
  
    func toggleView(initial: Bool){

        self.timerView.layer.opacity = 0

        self.timerStartButton.layer.opacity = 0

        self.timerStartButton.isUserInteractionEnabled = false
        if (initial){
            self.timeTextField.layer.opacity = 0
            self.timeTextField.isUserInteractionEnabled = false
            self.timerView.layer.opacity = 0
            self.hintLabel.layer.opacity = 0
            self.finishedLabel.layer.opacity = 0
        } else {
            self.timerStartButton.layer.opacity = 1
            self.timerStartButton.isUserInteractionEnabled = true

            self.timeTextField.layer.opacity = 1
            self.timeTextField.isUserInteractionEnabled = true
            self.hintLabel.layer.opacity = 1
            if (timerStarted) {
                self.timerView.layer.opacity = 1
            } else {
                countdownPickerTimer =  Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { (Timer) in
                    self.countdownPicker.sendActions(for: .valueChanged)
                }
            }
        }
    }
}
