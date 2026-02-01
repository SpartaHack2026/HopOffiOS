//
//  ViewController.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit

class SetUpViewController: UIViewController {
    
    @IBAction func imReadyTapped(_ sender: UIButton) {
        print("I'm Ready tapped")
        
        guard let nav = navigationController else {
            print("navigationController is nil — you are NOT embedded in a nav controller.")
            return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hobbiesVC = storyboard.instantiateViewController(withIdentifier: "HobbiesVC")
        hobbiesVC.modalPresentationStyle = .fullScreen
        present(hobbiesVC, animated: true)
        
        
    }
    
    @IBAction func learnMoreTapped(_ sender: UIButton) {
        guard let nav = navigationController else {
            print("navigationController is nil")
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let learnMoreVC = storyboard.instantiateViewController(withIdentifier: "AboutUsVC")

        nav.pushViewController(learnMoreVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

