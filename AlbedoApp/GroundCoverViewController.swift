//
//  GroundCoverViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/31/18.
//

import UIKit

class GroundCoverViewController: UIViewController {

    @IBOutlet weak var btnGrass: UIImageView!
    @IBOutlet weak var btnWetSoil: UIImageView!
    @IBOutlet weak var btnDrySoil: UIImageView!
    @IBOutlet weak var btnPavement: UIImageView!
    @IBOutlet weak var btnWoodenDeck: UIImageView!
    
    private var nextViewName = "SnowSurfaceViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let grassTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(grassTapped(grassTapped:)))
        btnGrass.isUserInteractionEnabled = true
        btnGrass.addGestureRecognizer(grassTapped)
        
        let wetSoilTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wetSoilTapped(wetSoilTapped:)))
        btnWetSoil.isUserInteractionEnabled = true
        btnWetSoil.addGestureRecognizer(wetSoilTapped)
        
        let drySoilTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(drySoilTapped(drySoilTapped:)))
        btnDrySoil.isUserInteractionEnabled = true
        btnDrySoil.addGestureRecognizer(drySoilTapped)
        
        let pavementTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pavementTapped(pavementTapped:)))
        btnPavement.isUserInteractionEnabled = true
        btnPavement.addGestureRecognizer(pavementTapped)
        
        let woodenDeckTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(woodenDeckTapped(woodenDeckTapped:)))
        btnWoodenDeck.isUserInteractionEnabled = true
        btnWoodenDeck.addGestureRecognizer(woodenDeckTapped)
    }
    
    func grassTapped(grassTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.groundCover = GroundCover.grass
    }
    
    func wetSoilTapped(wetSoilTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.groundCover = GroundCover.wetSoil
    }
    
    func drySoilTapped(drySoilTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.groundCover = GroundCover.drySoil
    }
    
    func pavementTapped(pavementTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.groundCover = GroundCover.pavement
    }
    
    func woodenDeckTapped(woodenDeckTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.groundCover = GroundCover.woodenDeck
    }
}

