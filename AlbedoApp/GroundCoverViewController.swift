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
    @IBOutlet weak var btnOther: UIImageView!
    
    var otherTextField: UITextField?
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
        
        let otherTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(otherTapped(otherTapped:)))
        btnOther.isUserInteractionEnabled = true
        btnOther.addGestureRecognizer(otherTapped)
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
    
    func otherTapped(otherTapped: UIGestureRecognizer) {
        // display a popup box for user to enter what "other" is
        openAlertView()
    }
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.otherTextField = textField! // Save reference to the UITextField
            self.otherTextField?.placeholder = "Enter ground cover here...";
        }
    }
    
    func openAlertView() {
        let alert = UIAlertController(title: "Other", message: "Enter the ground cover.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            if let enteredText = self.otherTextField?.text {
                print("entered", enteredText)
                PhotoData.groundCover = GroundCover.other
                PhotoData.otherGroundCover = enteredText
            }
            else {
                print("No text entered in 'other' field")
            }
            /*PhotoData.groundCover = GroundCover(rawValue: (self.otherTextField?.text)!)!*/
            let nextViewController = (self.storyboard?.instantiateViewController(withIdentifier: self.nextViewName))!
            self.present(nextViewController, animated: true)
        }))
        alert.addTextField(configurationHandler: configurationTextField)
        self.present(alert, animated: true, completion: nil)
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

