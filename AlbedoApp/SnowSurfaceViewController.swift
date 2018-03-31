//
//  SnowSurfaceViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/31/18.
//

import UIKit

class SnowSurfaceViewController: UIViewController {
    
    @IBOutlet weak var btnFreshSnow: UIImageView!
    @IBOutlet weak var btnSnow2Days: UIImageView!
    @IBOutlet weak var btnSnow3Days: UIImageView!
    @IBOutlet weak var btnSnow4Days: UIImageView!
    @IBOutlet weak var btnSnowOver4Days: UIImageView!
    @IBOutlet weak var btnDontKnow: UIImageView!
    
    private let nextViewName = "RootViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let freshSnowTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(freshSnowTapped(freshSnowTapped:)))
        btnFreshSnow.isUserInteractionEnabled = true
        btnFreshSnow.addGestureRecognizer(freshSnowTapped)
        
        let snow2DaysTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(snow2DaysTapped(snow2DaysTapped:)))
        btnSnow2Days.isUserInteractionEnabled = true
        btnSnow2Days.addGestureRecognizer(snow2DaysTapped)
        
        let snow3DaysTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(snow3DaysTapped(snow3DaysTapped:)))
        btnSnow3Days.isUserInteractionEnabled = true
        btnSnow3Days.addGestureRecognizer(snow3DaysTapped)
        
        let snow4DaysTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(snow4DaysTapped(snow4DaysTapped:)))
        btnSnow4Days.isUserInteractionEnabled = true
        btnSnow4Days.addGestureRecognizer(snow4DaysTapped)
        
        let snowOver4DaysTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(snowOver4DaysTapped(snowOver4DaysTapped:)))
        btnSnowOver4Days.isUserInteractionEnabled = true
        btnSnowOver4Days.addGestureRecognizer(snowOver4DaysTapped)
        
        let dontKnowTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dontKnowTapped(dontKnowTapped:)))
        btnDontKnow.isUserInteractionEnabled = true
        btnDontKnow.addGestureRecognizer(dontKnowTapped)
    }
    
    func freshSnowTapped(freshSnowTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.snowSurfaceAge = SnowSurfaceAge.fresh
    }
    
    func snow2DaysTapped(snow2DaysTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.snowSurfaceAge = SnowSurfaceAge.snow2Days
    }
    
    func snow3DaysTapped(snow3DaysTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.snowSurfaceAge = SnowSurfaceAge.snow3Days
    }
    
    func snow4DaysTapped(snow4DaysTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.snowSurfaceAge = SnowSurfaceAge.snow4Days
    }
    
    func snowOver4DaysTapped(snowOver4DaysTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.snowSurfaceAge = SnowSurfaceAge.snowOver4Days
    }
    
    func dontKnowTapped(dontKnowTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.snowSurfaceAge = SnowSurfaceAge.dontKnow
    }
}


