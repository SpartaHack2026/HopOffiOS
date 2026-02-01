//
//  ViewController.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit

class OpeningPageViewController: UIViewController {
    
    @IBOutlet weak var hopOffLabel: UILabel!
    @IBOutlet weak var hopOnLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        showRecommendation()
    }

    override func viewWillAppear(_ animated: Bool) {
        

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = UIColor(named: "Primary")
        
        setupMenuButton()
        
       
        print("NAV:", navigationController as Any)
        print("NAV BAR hidden:", navigationController?.isNavigationBarHidden as Any)

    }

    
    private func showRecommendation() {
        guard let rec = RecommendationManager.getRecommendation() else {
            hopOffLabel.text = "No apps selected"
            hopOnLabel.text = "Add activities to get started"
            return
        }

        hopOffLabel.text = "Hop off \(rec.app)"
        hopOnLabel.text = "Hop on \(rec.hobby.title)"
    }

    private func goBackToRouter() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let router = storyboard.instantiateViewController(withIdentifier: "LaunchRouterVC")

        if let nav = navigationController {
            nav.setViewControllers([router], animated: true)
        } else {
            router.modalPresentationStyle = .fullScreen
            present(router, animated: true)
        }
    }

    
    private func setupMenuButton() {
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(didTapMenu)
        )
        navigationItem.rightBarButtonItem = menuButton
    }
    
    @objc private func didTapMenu() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Change your list", style: .default) { _ in
            self.goToHobbiesForEditing()
        })
        sheet.addAction(UIAlertAction(title: "Reset onboarding (testing)", style: .destructive) { _ in
            AppDefaults.resetAllUserDataForTesting()
            self.goBackToRouter()
        })
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // iPad safety
        if let popover = sheet.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(sheet, animated: true)
    }
    
    private func goToHobbiesForEditing() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let hobbiesVC = storyboard.instantiateViewController(withIdentifier: "HobbiesVC") as? HobbiesViewController else {
            return
        }
        
        // Tell Hobbies VC it was opened from Opening Page
        hobbiesVC.entryMode = .editFromOpeningPage
        
        navigationController?.pushViewController(hobbiesVC, animated: true)
    }
    
}

