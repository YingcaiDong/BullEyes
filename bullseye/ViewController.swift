//
//  ViewController.swift
//  bullseye
//
//  Created by Yingcai Dong on 2016-08-28.
//  Copyright © 2016 Yingcai Dong. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    @IBOutlet weak var slider: UISlider! // get slider value
    
    // change label values
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var roundNumLabel: UILabel!
    
    var currentValue: Int = 0
    var targetValue: Int = 0
    var totalScore: Int = 0     // total score will add up
    var roundNumber: Int = 1
    var bouners: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startNewRound()
        self.updateLabels()
        ScoreLabel.text = String(0)
        roundNumLabel.text = String(1)
        
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: UIControlState())
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
            slider.setMinimumTrackImage(trackLeftResizable, for: UIControlState())
        }
        
        if let trackRightImage = UIImage(named: "SliderTrackRight") {
            let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
            slider.setMaximumTrackImage(trackRightResizable, for: UIControlState())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAlert() {
    
        let alertMessage:String
        
        if calcuScore() == 100 {
            alertMessage = "Perfect!"
            bouners = 100
        } else if 90 < calcuScore() && calcuScore() < 100 {
            alertMessage = "You almost had it!"
            bouners = 50
        } else {
            alertMessage = "Not even close..."
            bouners = 0
        }
        
        let message: String = "Your score is \(calcuScore()+bouners)"
        let sumScore: Int = calcuScore() + bouners
        
        print("showAlert - slider = \(slider.value)")
        print("showAlert - bouners = \(bouners)")
        print("showAlert - calcuScore = \(calcuScore())")
        
        let alert = UIAlertController(title: alertMessage, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Awesome", style: .default,
                                   handler: { action in
                                                self.startNewRound()
                                                self.updateLabels()
                                                self.updateScoreLable(sumScore)
                                            })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        //print("The value of the slider is \(slider.value)")
        
        currentValue = lroundf(slider.value)// do the same woke as the code above.
    }
    
    
    @IBAction func startOverButton() {
        startNewRound()
        totalScore = 0
        roundNumber += 1
        updateLabels()
        roundNumLabel.text = String(roundNumber)
        ScoreLabel.text = String(0)
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.add(transition, forKey: nil)
    }
    
    //=====================================
    // Method function
    //=====================================
    
    func startNewRound() {
        // regenerate random number
        targetValue = 1 + Int(arc4random_uniform(100))
        
        // put slider back to original position
        slider.value = 50
        
        currentValue = lroundf(slider.value)
    }
    
    func updateLabels() {
        targetLabel.text = String(targetValue)
    }
    
    // calculate score for each time
    // NOT the total score
    func calcuScore() -> Int {
        print("calcuScore -> substratcion = \(currentValue - targetValue)")
        return 100 - abs(currentValue - targetValue)
    }
    
    func updateScoreLable(_ sumScore: Int) {
        print("updateScoreLabel -> calcuScore = \(sumScore)")
        totalScore += sumScore
        print("updateScoreLabel -> totalScore = \(totalScore)\n")
        ScoreLabel.text = String(totalScore)
    }
}

