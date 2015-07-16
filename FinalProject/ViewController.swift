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
    var noteNamesWithSharps = ["C", "C♯","D","D♯","E","F","F♯","G","G♯","A","A♯","B"]
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var allNotesDisplay: UILabel!
    
    
    @IBOutlet weak var C: UIButton!
    @IBOutlet weak var Cs: UIButton!
    @IBOutlet weak var D: UIButton!
    @IBOutlet weak var Ds: UIButton!
    @IBOutlet weak var E: UIButton!
    @IBOutlet weak var F: UIButton!
    @IBOutlet weak var Fs: UIButton!
    @IBOutlet weak var G: UIButton!
    @IBOutlet weak var Gs: UIButton!
    @IBOutlet weak var A: UIButton!
    @IBOutlet weak var As: UIButton!
    @IBOutlet weak var B: UIButton!
    

    
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
            allKeysToNeutral()
            frequencyLabel.text="\(analyzer.trackedFrequency.value)"
            noteNameLabel.text="\(noteNamesWithSharps[index])"
            notePlayed(noteNamesWithSharps[index])
            allNotesDisplay.text = "\(allNotesDisplay.text! + noteNamesWithSharps[index])"
        }
    }
    
    func notePlayed(note: String)
    {
        switch note
        {
        case "\(noteNamesWithSharps[0])":
            C.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[1])":
            Cs.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[2])":
            D.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[3])":
            Ds.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[4])":
            E.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[5])":
            F.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[6])":
            Fs.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[7])":
            G.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[8])":
            Gs.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[9])":
            A.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[10])":
            As.backgroundColor = UIColor.redColor()
        case "\(noteNamesWithSharps[11])":
            B.backgroundColor = UIColor.redColor()

        default:
            allKeysToNeutral()
        }
    }
    
    func allKeysToNeutral()
    {
        C.backgroundColor = UIColor.greenColor()
        Cs.backgroundColor = UIColor.blackColor()
        D.backgroundColor = UIColor.greenColor()
        Ds.backgroundColor = UIColor.blackColor()
        E.backgroundColor = UIColor.greenColor()
        F.backgroundColor = UIColor.greenColor()
        Fs.backgroundColor = UIColor.blackColor()
        G.backgroundColor = UIColor.greenColor()
        Gs.backgroundColor = UIColor.blackColor()
        A.backgroundColor = UIColor.greenColor()
        As.backgroundColor = UIColor.blackColor()
        B.backgroundColor = UIColor.greenColor()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

