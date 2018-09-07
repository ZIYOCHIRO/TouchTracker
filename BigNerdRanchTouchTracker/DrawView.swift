//
//  DrawView.swift
//  BigNerdRanchTouchTracker
//
//  Created by 10.12 on 2018/9/7.
//  Copyright © 2018 Rui. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLine: Line?
    var finishedLines = [Line]()

    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = CGLineCap.round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        UIColor.black.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        
        // Draw current line in red
        if let line = currentLine {
            // if there is a line currently being drawn, do it in red
            UIColor.red.setStroke()
            strokeLine(line: line)
        }
    }
    
    // Creat line object  && get location of current touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        // Get location of thet touch in view's coordinate system
        let location = touch.location(in: self)
        
        currentLine = Line(begin: location, end: location)
        
        setNeedsDisplay()
    }
    
    // get location of currentLine's end
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        currentLine?.end = location
        
        setNeedsDisplay()
    }
    
    // put currentLine in the finishedLines
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            finishedLines.append(line)
        }
        currentLine = nil
        
        setNeedsDisplay()
    }
}