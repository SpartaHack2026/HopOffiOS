//
//  ViewController.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit
import AVKit


class InstructionsViewController: UIViewController {
    
    @IBOutlet weak var hopOn: UIButton!
    
    private var playerViewController: AVPlayerViewController?
    private var player: AVPlayer?
    
    @IBOutlet weak var videoContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupEmbeddedVideo()
    }
    
    @IBAction func finishedOnboardingBtn(_ sender: UIButton) {  
        // 1️⃣ Permanently mark onboarding as completed
        AppDefaults.setHasOnboarded(true)

        // 2️⃣ Load Opening Page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let openingVC = storyboard.instantiateViewController(withIdentifier: "OpeningPageVC")

        // 3️⃣ Reset navigation stack so onboarding is gone
        if let nav = navigationController {
            nav.setViewControllers([openingVC], animated: true)
        } else {
            // Safety fallback (should not happen if nav is set up correctly)
            openingVC.modalPresentationStyle = .fullScreen
            present(openingVC, animated: true)
        }
    }

    
    private func setupEmbeddedVideo() {
            // 1) Find the local video in the app bundle
            guard let url = Bundle.main.url(forResource: "onboarding", withExtension: "mp4") else {
                print("Video not found. Check filename + target membership.")
                return
            }

            // 2) Create player
            let player = AVPlayer(url: url)
            self.player = player

            // 3) Create AVPlayerViewController
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            playerVC.showsPlaybackControls = true

            // 4) Embed it as a child VC
            addChild(playerVC)
            playerVC.view.frame = videoContainerView.bounds
            playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            videoContainerView.addSubview(playerVC.view)
            playerVC.didMove(toParent: self)

            self.playerViewController = playerVC

            // 5) Auto-play (remove if you only want it to play when user taps)
            player.play()
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            // Stop playback when leaving the screen
            player?.pause()
        }
    
    
}

