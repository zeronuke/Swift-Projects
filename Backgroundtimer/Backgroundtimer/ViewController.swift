//
//  ViewController.swift
//  Backgroundtimer
//
//  Created by Mark Shen on 11/27/21.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var timeLabel: UILabel!
  
  var timerCounting:Bool = false
  var startTime:Date?
  var stopTime:Date?
  
  var scheduledTimer:Timer!
  
  let userDefaults = UserDefaults.standard
  let START_TIME_KEY = "startTime"
  let STOP_TIME_KEY = "stopTime"
  let COUNTING_TIME_KEY = "countTime"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
    stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
    timerCounting = userDefaults.bool(forKey: COUNTING_TIME_KEY)
    // Do any additional setup after loading the view.
    if timerCounting {
      startTimer()
    } else {
      stopTimer()
      if let start = startTime {
        if let stop = stopTime {
          let time = calcRestartTime(start: start, stop: stop)
          let diff = Date().timeIntervalSince(time)
          setTimeLabel(Int(diff))
        }
      }
    }
  }
  
  @IBAction func resetAction(_ sender: Any) {
    setStopTime(date: nil)
    setStartTime(date: nil)
    timeLabel.text = makeTimeString(hour: 0, minute: 0, second: 0)
    stopTimer()
  }
  
  func startTimer() {
    scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
    setTimerCounting(val: true)
//    startButton.setTitle("STOP", for: .normal)
//    startButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
    startButton.setTitleColor(UIColor.red, for: .normal)
  }

  func stopTimer() {
    if scheduledTimer != nil {
      scheduledTimer.invalidate()
    }
    setTimerCounting(val: false)
    startButton.setTitle("START", for: .normal)
//    startButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
    startButton.setTitleColor(UIColor.blue, for: .normal)
  }
  
  
  @objc func refreshValue() {
    if let start = startTime {
      let diff = Date().timeIntervalSince(start)
      setTimeLabel(Int(diff))
    } else {
      stopTimer()
      setTimeLabel(0)
    }
  }
  
  func setTimeLabel(_ val: Int) {
    let time = secondsToHoursMinutesSeconds(val)
    let timeString = makeTimeString(hour: time.0, minute: time.1, second: time.2)
    timeLabel.text = timeString
  }
  
  func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int)  {
      let hour = seconds/3600
      let min = (seconds % 3600) / 60
      let secondss = (seconds % 3600) % 60
    return (hour, min, secondss)
  }

  func makeTimeString(hour: Int, minute: Int, second: Int) -> String {
    let timeString = String(format: "%02d : %02d : %02d", hour, minute, second)
    return timeString
  }

  @IBAction func startStopAction(_ sender: Any) {
    if timerCounting {
      setStopTime(date: Date())
      stopTimer()
    } else {
      if let stop = stopTime {
        
        let restartTime = calcRestartTime(start: startTime!, stop: stop)
        setStopTime(date: nil)
        setStartTime(date: restartTime)
      } else {
        setStartTime(date: Date())
      }
      startTimer()
    }
  }
  
  func calcRestartTime(start: Date, stop: Date) -> Date {
    let diff = start.timeIntervalSince(stop)
    return Date().addingTimeInterval(diff)
    
  }
  
  func setStartTime(date: Date?) {
    startTime = date
    userDefaults.set(date, forKey:START_TIME_KEY)
  }
  func setStopTime(date: Date?) {
    stopTime = date
    userDefaults.set(date, forKey:STOP_TIME_KEY)
  }
  func setTimerCounting(val: Bool) {
    timerCounting = val
    userDefaults.set(timerCounting, forKey:COUNTING_TIME_KEY)
  }
}

