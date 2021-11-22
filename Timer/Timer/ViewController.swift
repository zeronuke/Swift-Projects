//
//  ViewController.swift
//  Timer
//
//  Created by Mark Shen on 11/17/21.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var checkParents: UIButton!
  
  @IBOutlet weak var purpleView: UIView!
  @IBOutlet weak var pinkView: UIView!
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var startStopButton: UIButton!
  @IBOutlet weak var TimerLabel: UILabel!
  
  var timer:Timer = Timer()
  var count:Int = 0
  var timeCounting:Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startStopButton.setTitleColor(UIColor.green, for: .normal)
    // Do any additional setup after loading the view.
  }

  @IBAction func resetTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you want to reset the timer?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
      // do nothing
    }))
    alert.addAction(UIAlertAction(title: "RESET", style: .default, handler: { (_) in
      self.timer.invalidate()
      self.timeCounting = false
      self.count = 0
      self.TimerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
    }))
    self.present(alert, animated: true, completion: nil)
  }
  @IBAction func checkParents(_ sender: Any) {
    let mutableSet:NSMutableSet = NSMutableSet()
    var viewA = pinkView
    var viewB = startStopButton as UIView
    mutableSet.add(viewA)
    while (viewA?.superview != nil) {
      viewA = viewA!.superview
      mutableSet.add(viewA)
    }
    while (!mutableSet.contains(viewB) && viewB != nil) {
      viewB = viewB.superview!
    }
    if (viewB == nil) {
      NSLog(@"no common parent");
    } else {
      NSLog("Common parent is %@\n", viewB);
    }
  
  }
  @IBAction func startStopTapped(_ sender: Any) {
    if (timeCounting) {
      timer.invalidate()
      timeCounting = false
      startStopButton.setTitle("START", for: .normal)
      startStopButton.setTitleColor(UIColor.green, for: .normal)
    } else {
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(timerCounter), userInfo: nil, repeats: true)
      startStopButton.setTitleColor(UIColor.red, for: .normal)
      startStopButton.setTitle("STOP", for: .normal)
      timeCounting = true
    }
  }
  @objc func timerCounter () -> Void
  {
    count += 1;
    let time = secondsToHoursMinutesSeconds(seconds: count)
    TimerLabel.text = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
  }
  func secondsToHoursMinutesSeconds (seconds:Int) ->  (Int, Int, Int)
  {
    let hours = seconds / 3600;
    let minutes = (seconds % 3600) / 60
    let seconds = (seconds % 60)
    return (hours, minutes, seconds)
  }

  func makeTimeString (hours: Int, minutes: Int, seconds: Int) -> String
  {
    var timeString = ""
    timeString += String(format: "%02d", hours)
    timeString += " : "
    timeString += String(format: "%02d", minutes)
    timeString += " : "
    timeString += String(format: "%02d", seconds)
    return timeString
  }
}

