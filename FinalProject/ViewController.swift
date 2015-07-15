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
    var noteFrequencies = [16.35,17.32,18.35,19.45,20.6,21.83,23.12,24.5,25.96,27.5,29.14,30.87]
    var noteNamesWithFlats  = ["C", "D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var allNotesDisplay: UILabel!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mic = Microphone()
        AKOrchestra.addInstrument(mic)
        analyzer = AKAudioAnalyzer(audioSource: mic.auxilliaryOutput)
        AKOrchestra.addInstrument(analyzer)
        println("Loaded")
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        analyzer.start()
        mic.start()
        allNotesDisplay.text = ""
        
        updateAnalysis = AKEvent(block: {
            self.updateUI()
            self.analysisSequence.addEvent(self.updateAnalysis, afterDuration: 0.1)
            println("Analysis Updated")
        })
        analysisSequence.addEvent(updateAnalysis)
        analysisSequence.play()
        println("did appear")
    }
    
    func updateUI()
    {
        println("UI updated")
        println(analyzer.trackedFrequency.value)

        var frq = abs(Double(analyzer.trackedFrequency.value))
        while frq > noteFrequencies.last
        {
            println("greater")
            frq = frq / 2.0
        }
        while frq < noteFrequencies.first && frq != 0
        {
            println("lower")
            frq = frq * 2
        }
        println(frq)
        
        var minDistance = Double(10000);
        var index = 0;
        for var count = 0; count < noteFrequencies.count; count++
        {
//            println(index)
            var distance = abs(noteFrequencies[count] - frq)
            if distance < minDistance
            {
                index = count
                minDistance = distance
            }
        }
        
        if analyzer.trackedAmplitude.value > 0.001
        {
            frequencyLabel.text="\(analyzer.trackedFrequency.value)"
            noteNameLabel.text="\(noteNamesWithFlats[index])"
            allNotesDisplay.text = "\(allNotesDisplay.text! + noteNamesWithFlats[index])"
        }

        
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

