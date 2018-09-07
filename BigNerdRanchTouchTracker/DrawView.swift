//
//  DrawView.swift
//  BigNerdRanchTouchTracker
//
//  Created by 10.12 on 2018/9/7.
//  Copyright © 2018 Rui. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    

    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        finishedLineColor.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        
        // Draw current line in red
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            strokeLine(line: line)
        }
    }
    
    // Creat line object  && get location of current touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Let's put in a log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    // get location of currentLine's end
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    // put currentLine in the finishedLines
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in:self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Let's put in a log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
}
