//
//  GroundCoverViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/31/18.
//

import UIKit

class GroundCoverViewController: UIViewController {

    @IBOutlet weak var btnGrassLiving: UIImageView!
    @IBOutlet weak var btnGrassDead: UIImageView!
    @IBOutlet weak var btnWetSoil: UIImageView!
    @IBOutlet weak var btnDrySoil: UIImageView!
    @IBOutlet weak var btnPavement: UIImageView!
    @IBOutlet weak var btnWoodenDeck: UIImageView!
    
    private var nextViewName = "RootViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let grassLivingTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(grassLivingTapped(grassLivingTapped:)))
        btnGrassLiving.isUserInteractionEnabled = true
        btnGrassLiving.addGestureRecognizer(grassLivingTapped)
        
        let grassDeadTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(grassDeadTapped(grassDeadTapped:)))
        btnGrassDead.isUserInteractionEnabled = true
        btnGrassDead.addGestureRecognizer(grassDeadTapped)
        
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
    
    func grassLivingTapped(grassLivingTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.groundCover = GroundCover.grassLiving
    }
    
    func grassDeadTapped(grassDeadTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.groundCover = GroundCover.grassDead
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
    
    @IBAction func btnBackTapped(_ sender: Any) {
        if PhotoData.snowState == SnowState.snowFreeDormant || PhotoData.snowState == SnowState.snowFreeGreen {
            let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SnowStateViewController"))!
            self.present(prevViewController, animated: true)
        } else {
            let prevViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SnowSurfaceAgeViewController"))!
            self.present(prevViewController, animated: true)
        }
    }
}

