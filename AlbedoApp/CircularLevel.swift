//
//  CircularLevel.swift
//  AlbedoApp
//
//  Created by crt2004 on 2/23/18.
//
//  This class creates a circular level
//

import UIKit
import CoreMotion

class CircularLevel: UIView {
    
    var outerCircle: UIView!
    var innerCircle: UIView!
    var dot: UIView!
    let kFilteringFactor = 0.05
    let kNoReadingValue: Float = 999.0
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    let viewInset: Float = 17.0
    let acceptableDistance: Float = 12.0
    
    var firstCalibrationReading: Float!
    var calibrationOffset: Float!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.outerCircle = makeCircle(diameter: 150, borderWidth: 8, color: UIColor.black)
        self.innerCircle = makeCircle(diameter: 30, borderWidth: 2, color: UIColor.black)
        self.dot = makeCircle(diameter: 8, borderWidth: 4, color: UIColor.red)
    
        /*UIView.animate(withDuration: 0.25) {
            var xCoord = 10
            var yCoord = 10
            self.dot.center = CGPoint(x:10, y:10)
        }*/
        
        calibrationOffset = 0.0
        firstCalibrationReading = kNoReadingValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // makes a circle with the specified diameter, border width, and color. The circle is centered on the screen.
    func makeCircle(diameter: CGFloat, borderWidth: CGFloat, color: UIColor) -> UIView {
        let circle = UIView(frame: CGRect(x:0.0, y:0.0, width:diameter, height:diameter))
        circle.center = CGPoint(x:self.width / 2, y:self.height / 2) // center the circle in the view
        circle.layer.cornerRadius = diameter / 2.0 // half of frame width to make a circle
        circle.layer.borderColor = color.cgColor
        circle.layer.borderWidth = borderWidth
        circle.clipsToBounds = true
        self.addSubview(circle)
        return circle
    }
    
    func calibrateAngleFromAngle(angle: Double) -> Float {
        return calibrationOffset + Float(angle)
    }
    
    func updatePos(accelX: Double, accelY: Double) {
        //print("accelX: \(accelX) accelY: \(accelY)")
        //let accX = accelX * kFilteringFactor + accelX * (1.0 - kFilteringFactor)
        //let accY = accelY * kFilteringFactor + accelY * (1.0 - kFilteringFactor)
        
        let tiltDirection = atan2(accelY, accelX)
        var calibratedAngle = calibrateAngleFromAngle(angle: tiltDirection)
        
        //let tiltMagnitude = min(1, sqrt((accelX * accelX) + (accelY * accelY)))
        //var newY = CGFloat(sin(tiltDirection) * tiltMagnitude)
        //var newX = CGFloat(-cos(tiltDirection) * tiltMagnitude)
        
        //newX += self.dot.center.x
        //newY += self.dot.center.y
        
        //print("newX: \(newX) newY: \(newY)")
        //print("tiltMagnitude: \(tiltMagnitude)")
        
        //self.dot.center = CGPoint(x:newX, y:newY)
    }
    
    func getPoint(attitude: CMAttitude) -> CGPoint {
        let ratio: CGFloat = 120.0 / 25.0
        let roll = CGFloat(attitude.roll)
        let pitch = CGFloat(attitude.pitch)
        
        var point = CGPoint(x:(roll * ratio), y:(pitch * ratio))
        let halfOfWidth: Float = Float(self.width) / 2.0
        
        point.x = (point.x + CGFloat.pi) / (2 * CGFloat.pi) * self.width
        point.y = (point.y + CGFloat.pi) / (2 * CGFloat.pi) * self.width
        
        let maxDistance = halfOfWidth - self.viewInset
        let distance = sqrtf(powf(Float(point.x) - halfOfWidth, 2) + powf(Float(point.y) - halfOfWidth, 2))
        
        if distance > maxDistance {
            let pointCartesian = convertScreenPointToCartesianCoordSystem(point: point)
            let angle: CGFloat = atan2(pointCartesian.y, pointCartesian.x)
            
            point = CGPoint(x: cos(angle) * CGFloat(maxDistance), y: sin(angle) * CGFloat(maxDistance))
            point = convertCartesianPointToScreenCoordSystem(point: point)
        }
        
        if distance < acceptableDistance {
            self.dot.layer.borderColor = UIColor.green.cgColor
        } else {
            self.dot.layer.borderColor = UIColor.red.cgColor
        }
        
        point = CGPoint(x: self.width - point.x, y: self.width - point.y)
        return point
    }
    
    func convertScreenPointToCartesianCoordSystem(point: CGPoint) -> CGPoint {
        let x: CGFloat = point.x - (self.width / 2.0)
        let y: CGFloat = point.y - (self.height / 2.0) * -1
        return CGPoint(x: x, y: y)
    }
    
    func convertCartesianPointToScreenCoordSystem(point: CGPoint) -> CGPoint {
        let x: CGFloat = point.x + (self.width / 2.0)
        let y: CGFloat = (point.y * -1) + (self.height / 2.0)
        return CGPoint(x: x, y: y)
    }
}

