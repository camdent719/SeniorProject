//
//  CircularLevel.swift
//  AlbedoApp
//
//  Created by crt2004 on 2/23/18.
//
//  This class creates a circular level.
//  Algorithm for leveling calculations adapted from: https://github.com/stephsharp/SpiritLevelCircle
//

import UIKit
import CoreMotion

class CircularLevel: UIView {
    
    private var outerCircle: UIView!
    private var innerCircle: UIView!
    private var ball: UIView! // this is the level ball that moves
    private var width: CGFloat = 0.0
    private var height: CGFloat = 0.0
    
    //let viewInset: Float = 17.0
    private let distanceRange: Float = 12.0 // distance to determine UI color change for level ball
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
        self.outerCircle = makeCircle(diameter: 150, borderWidth: 8, color: UIColor.black)
        self.innerCircle = makeCircle(diameter: 30, borderWidth: 2, color: UIColor.black)
        self.ball = makeCircle(diameter: 8, borderWidth: 4, color: UIColor.red)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // makes a circle with the specified diameter, border width, and color. The circle is centered on the
    // screen. this function is used to make the three UI components that make up the level.
    private func makeCircle(diameter: CGFloat, borderWidth: CGFloat, color: UIColor) -> UIView {
        let circle = UIView(frame: CGRect(x:0.0, y:0.0, width:diameter, height:diameter))
        circle.center = CGPoint(x:self.width / 2, y:self.height / 2) // center the circle in the view
        circle.layer.cornerRadius = diameter / 2.0 // half of frame width to make a circle
        circle.layer.borderColor = color.cgColor
        circle.layer.borderWidth = borderWidth
        circle.clipsToBounds = true
        self.addSubview(circle)
        return circle
    }
    
    // this function calculates the center point of the level ball based on the devices roll and pitch
    // from CameraViewController.swift
    public func getPoint(attitude: CMAttitude) {
        let ratio: CGFloat = 120.0 / 25.0
        let roll = CGFloat(attitude.roll)
        let pitch = CGFloat(attitude.pitch)
        
        var point = CGPoint(x:(roll * ratio), y:(pitch * ratio))
        let halfOfWidth: Float = Float(self.width) / 2.0
        let halfOfHeight: Float = Float(self.height) / 2.0
        
        point.x = (point.x + CGFloat.pi) / (2 * CGFloat.pi) * self.width
        point.y = (point.y + CGFloat.pi) / (2 * CGFloat.pi) * self.height
        
        //let maxDistance = halfOfWidth - self.viewInset
        let distance = sqrtf(powf(Float(point.x) - halfOfWidth, 2) + powf(Float(point.y) - halfOfHeight, 2))
        
        /*if distance > maxDistance {
            let pointCartesian = convertScreenPointToCartesianCoordSystem(point: point)
            let angle: CGFloat = atan2(pointCartesian.y, pointCartesian.x)
            
            point = CGPoint(x: cos(angle) * CGFloat(maxDistance), y: sin(angle) * CGFloat(maxDistance))
            point = convertCartesianPointToScreenCoordSystem(point: point)
        }*/
        
        if distance < self.distanceRange { // if the distance is within the range, change the ball to green
            self.ball.layer.borderColor = UIColor.green.cgColor
        } else {
            self.ball.layer.borderColor = UIColor.red.cgColor
        }
        
        point = CGPoint(x: self.width - point.x, y: self.height - point.y)
        self.ball.center = point
    }
    
    // converts a UI screen point to the Cartesian coordinate system used to measure radians
    private func convertScreenPointToCartesianCoordSystem(point: CGPoint) -> CGPoint {
        let x: CGFloat = point.x - (self.width / 2.0)
        let y: CGFloat = point.y - (self.height / 2.0) * -1
        return CGPoint(x: x, y: y)
    }
    
    // converts a Cartesian coordinate system point uesd to measure radians to a UI screen point
    private func convertCartesianPointToScreenCoordSystem(point: CGPoint) -> CGPoint {
        let x: CGFloat = point.x + (self.width / 2.0)
        let y: CGFloat = (point.y * -1) + (self.height / 2.0)
        return CGPoint(x: x, y: y)
    }
}
