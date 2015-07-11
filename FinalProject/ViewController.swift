//
//  ViewController.swift
//  FinalProject
//
//  Created by Cluster 5 on 7/10/15.
//  Copyright (c) 2015 com.yeejay. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    var mic = Microphone()
    var analyzer = AKAudioAnalyzer()
    var updateAnalysis = AKEvent()
    var analysisSequence = AKSequence()
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var noteNameLabel: UILabel!//
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mic = Microphone()
        AKOrchestra.addInstrument(mic)
        analyzer = AKAudioAnalyzer(audioSource: mic.auxilliaryOutput)
        AKOrchestra.addInstrument(analyzer)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        analyzer.start()
        mic.start()
        
        updateAnalysis = AKEvent(block: {
            self.updateUI()
            self.analysisSequence.addEvent(self.updateAnalysis, afterDuration: 0.1)
        })
    }
    
    func updateUI()
    {
        println(analyzer.trackedFrequency.value)
        if analyzer.trackedAmplitude.value > 0.1
        {
            frequencyLabel.text="\(analyzer.trackedFrequency.value)"
        }
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

