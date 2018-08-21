//
//  SnowStateViewController.swift
//  AlbedoApp
//
//  Created by AlbedoDev on 3/31/18.
//

import UIKit

class SnowStateViewController: UIViewController {
    
    @IBOutlet weak var btnSnowCovered: UIImageView!
    @IBOutlet weak var btnPatchySnow: UIImageView!
    @IBOutlet weak var btnSnowFreeDormant: UIImageView!
    @IBOutlet weak var btnSnowFreeGreen: UIImageView!
    
    private let nextViewName = "GroundCoverViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let snowCoveredTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(snowCoveredTapped(snowCoveredTapped:)))
        btnSnowCovered.isUserInteractionEnabled = true
        btnSnowCovered.addGestureRecognizer(snowCoveredTapped)
        
        let patchySnowTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(patchySnowTapped(patchySnowTapped:)))
        btnPatchySnow.isUserInteractionEnabled = true
        btnPatchySnow.addGestureRecognizer(patchySnowTapped)
        
        let snowFreeDormantTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(snowFreeDormantTapped(snowFreeDormantTapped:)))
        btnSnowFreeDormant.isUserInteractionEnabled = true
        btnSnowFreeDormant.addGestureRecognizer(snowFreeDormantTapped)
        
        let snowFreeGreenTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(snowFreeGreenTapped(snowFreeGreenTapped:)))
        btnSnowFreeGreen.isUserInteractionEnabled = true
        btnSnowFreeGreen.addGestureRecognizer(snowFreeGreenTapped)
    }
    
    func snowCoveredTapped(snowCoveredTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SnowSurfaceAgeViewController"))!
        self.present(nextViewController, animated: true)
        PhotoData.snowState = SnowState.snowCovered
        PhotoData.patchinessPercentage = 100
    }
    
    func patchySnowTapped(patchySnowTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PatchinessViewController"))!
        self.present(nextViewController, animated: true)
        PhotoData.snowState = SnowState.patchySnow
    }
    
    func snowFreeDormantTapped(snowFreeDormantTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.snowState = SnowState.snowFreeDormant
        PhotoData.patchinessPercentage = 0
        PhotoData.groundCover = GroundCover.grassDead // if there is no snow and is dormant, we know the ground cover is grass
    }
    
    func snowFreeGreenTapped(snowFreeGreenTapped: UIGestureRecognizer) {
        let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: nextViewName))!
        self.present(nextViewController, animated: true)
        PhotoData.snowState = SnowState.snowFreeGreen
        PhotoData.patchinessPercentage = 0
        PhotoData.groundCover = GroundCover.grassLiving // if there is no snow and is green, we know the ground cover is grass
    }
}
