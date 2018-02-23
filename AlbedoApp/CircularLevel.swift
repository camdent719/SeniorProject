//
//  CircularLevel.swift
//  AlbedoApp
//
//  Created by crt2004 on 2/23/18.
//
//  This class creates a circular level
//

import UIKit

class CircularLevel: UIView {
    
    var outerCircle: UIView!
    var innerCircle: UIView!
    var dot: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.outerCircle = makeCircle(diameter: 150, borderWidth: 8, color: UIColor.black)
        self.innerCircle = makeCircle(diameter: 30, borderWidth: 2, color: UIColor.black)
        self.dot = makeCircle(diameter: 8, borderWidth: 4, color: UIColor.red)
        
        /*UIView.animate(withDuration: 0.25) {
            var xCoord = 10
            var yCoord = 10
            self.dot.center = CGPoint(x:10, y:10)
        }*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // makes a circle with the specified diameter, border width, and color. The circle is centered on the screen.
    func makeCircle(diameter: CGFloat, borderWidth: CGFloat, color: UIColor) -> UIView {
        let circle = UIView(frame: CGRect(x:0.0, y:0.0, width:diameter, height:diameter))
        circle.center = CGPoint(x:frame.width / 2, y:frame.height / 2) // center the circle in the view
        circle.layer.cornerRadius = diameter / 2.0 // half of frame width to make a circle
        circle.layer.borderColor = color.cgColor
        circle.layer.borderWidth = borderWidth
        circle.clipsToBounds = true
        self.addSubview(circle)
        return circle
    }
    
    func updatePos(accelX: Double, accelY: Double) {
        //print("accelX: \(accelX) accelY: \(accelY)")
        let tiltDirection = atan2(accelY, accelX)
        
        let tiltMagnitude = min(1, sqrt((accelX * accelX) + (accelY * accelY)))
        var newY = CGFloat(sin(tiltDirection) * tiltMagnitude)
        var newX = CGFloat(-cos(tiltDirection) * tiltMagnitude)
        
        newX += self.dot.center.x
        newY += self.dot.center.y
        
        //print("newX: \(newX) newY: \(newY)")
        //print("tiltMagnitude: \(tiltMagnitude)")
        
        self.dot.center = CGPoint(x:newX, y:newY)
    }
}

