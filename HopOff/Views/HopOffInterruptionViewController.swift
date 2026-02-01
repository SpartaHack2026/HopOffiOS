//
//  HopOffInterruptionViewController.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit

final class HopOffInterruptionViewController: UIViewController {

    var timeoutSeconds: TimeInterval = 8

    private var timer: Timer?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: timeoutSeconds, repeats: false) { [weak self] _ in
            self?.returnToOpeningWithNewSuggestion()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func returnToOpeningWithNewSuggestion() {
        if presentingViewController != nil {
            dismiss(animated: true)
            return
        }

        if let nav = navigationController {
            nav.popViewController(animated: true)
        }
    }

    @IBAction func didTapImStaying(_ sender: UIButton) {
        returnToOpeningWithNewSuggestion()
    }
}

