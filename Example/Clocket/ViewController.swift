//
//  ViewController.swift
//  Clocket-development
//
//  Created by Andrey Filonov on 08/11/2018.
//  Copyright © 2019 Andrey Filonov. All rights reserved.
//


import UIKit
import AVFoundation
import Clocket

class ViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeRateLabel: UILabel!
    @IBOutlet weak var displayRealTimeSwitch: UISwitch!
    @IBOutlet weak var countDownSwitch: UISwitch!
    @IBOutlet weak var manualTimeSetSwitch: UISwitch!
    @IBOutlet weak var timeRateStepper: UIStepper!
    @IBOutlet var controlPanels: [UIView]!
    
    @IBOutlet weak var clock: Clocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clock.clocketDelegate = self
        setupView()
        setupClock()
    }
    
    @IBAction
    func startButtonTapped(_ sender: Any) {
        clock.startClock()
        if clock.timer.isValid {
            startButton.setTitle("STOP", for: .normal)
        } else {
            startButton.setTitle("START", for: .normal)
        }
    }
    
    func setupView() {
        controlPanels.forEach { (p: UIView) in
            p.layer.cornerRadius = p.bounds.height/2
            p.backgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
        }
    }
    
    func setupClock() {
        displayRealTimeSwitch.addTarget(self, action: #selector(realTimeSwitchStateChanged), for: UIControl.Event.valueChanged)
        displayRealTimeSwitch.setOn(false, animated: true)
        clock.displayRealTime = false
        
        countDownSwitch.addTarget(self, action: #selector(countDownSwitchStateChanged), for: UIControl.Event.valueChanged)
        countDownSwitch.setOn(false, animated: true)
        
        manualTimeSetSwitch.addTarget(self, action: #selector(manualTimeSetSwitchStateChanged), for: UIControl.Event.valueChanged)
        
        timeRateStepper.addTarget(self, action: #selector(timeRateStepperValueChanged), for: UIControl.Event.valueChanged)
        timeRateStepper.minimumValue = -10
        timeRateStepper.maximumValue = 10
        timeRateStepper.value = 1.0/clock.refreshInterval
        timeRateLabel.text = String(Int(timeRateStepper.value)) + "X"
        
        // delayed start for the real time clock
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(startRealTimeClock), userInfo: nil, repeats: false)
    }
    
    func setTimeRate(timeRate: Double) {
        clock.refreshInterval = Double(1.0/abs(timeRate))
        timeRateStepper.value = timeRate
        timeRateLabel.text = String(Int(timeRate)) + "X"
        if clock.timer.isValid {
            clock.stopClock()
            clock.startClock()
        }
    }
    
    
    @objc
    func startRealTimeClock() {
        clock.displayRealTime = true
        displayRealTimeSwitch.setOn(true, animated: true)
        clock.refreshInterval = Double(1.0)
        startButton.setTitle("STOP", for: .normal)
        clock.startClock()
    }
    
    @objc
    func realTimeSwitchStateChanged(switchState: UISwitch) {
        if switchState.isOn {
            clock.displayRealTime = true
            clock.reverseTime = false
            
            countDownSwitch.setOn(false, animated: true)
            clock.countDownTimer = false
            
            setTimeRate(timeRate: 1.0)
            if !clock.timer.isValid {
                clock.startClock()
            }
            startButton.setTitle("STOP", for: .normal)
        } else {
            clock.displayRealTime = false
        }
    }
    
    
    @objc
    func countDownSwitchStateChanged(switchState: UISwitch) {
        clock.stopClock()
        startButton.setTitle("START", for: .normal)
        
        if switchState.isOn {
            clock.countDownTimer = true
            
            clock.displayRealTime = false
            displayRealTimeSwitch.setOn(false, animated: true)
            
            manualTimeSetSwitch.setOn(true, animated: true)
            clock.manualTimeSetAllowed = true
            
            clock.setLocalTime(hour: 0, minute: 0, second: 5)
            clock.reverseTime = true
            setTimeRate(timeRate: -1.0)
        } else {
            clock.countDownTimer = false
        }
    }
    
    
    @objc
    func timeRateStepperValueChanged(_ sender: UIStepper) {
        displayRealTimeSwitch.setOn(false, animated: true)
        clock.displayRealTime = false
        
        if Int(sender.value) == 0 {
            if clock.countDownTimer {
                sender.value = -1
            } else {
                if clock.reverseTime {
                    sender.value = 1
                    clock.reverseTime = false
                } else {
                    sender.value = -1
                    clock.reverseTime = true
                }
            }
        }
        setTimeRate(timeRate: sender.value)
    }
    
    @objc
    func manualTimeSetSwitchStateChanged(switchState: UISwitch) {
        clock.manualTimeSetAllowed = switchState.isOn
    }
}

extension ViewController: ClocketDelegate {
    
    func timeIsSetManually() {
        clock.displayRealTime = false
        displayRealTimeSwitch.setOn(false, animated: true)
    }
    
    func clockStopped() {
        startButton.setTitle("START", for: .normal)
    }
    
    func countDownExpired() {
        startButton.setTitle("START", for: .normal)
        clock.countDownTimer = false
        clock.reverseTime = false
        countDownSwitch.setOn(false, animated: true)
        setTimeRate(timeRate: 1.0)
        
        let localTimeComponents: Set<Calendar.Component> = [.hour, .minute, .second]
        let currentTime = Calendar.current.dateComponents(localTimeComponents, from: Date())
        print("Countdown timer expired at", String(currentTime.hour!) + ":" +
            String(currentTime.minute!) + ":"
            + String(currentTime.second!))
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
