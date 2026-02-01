//
//  ViewController.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit

class LaunchRouterViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        routeUser()
    }
    
    private func routeUser() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let nextVC: UIViewController
            if AppDefaults.hasOnboarded {
                nextVC = storyboard.instantiateViewController(withIdentifier: "OpeningPageVC")
            } else {
                nextVC = storyboard.instantiateViewController(withIdentifier: "SetUpMenuVC")
            }

            // Recommended: embed router in a Navigation Controller in storyboard.
            if let nav = navigationController {
                nav.setViewControllers([nextVC], animated: false)
            } else {
                nextVC.modalPresentationStyle = .fullScreen
                present(nextVC, animated: false)
            }
        }

}

