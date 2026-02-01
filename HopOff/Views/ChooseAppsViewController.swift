//
//  ViewController.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit

class ChooseAppsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let options = [
        "TikTok",
        "Instagram",
        "Snapchat",
        "Facebook",
        "YouTube",
        "X"
    ]
    
    private var selectedIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        makeTableTransparent()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyAppGradient()
        view.updateAppGradientFrame() 
    }
    
    private func makeTableTransparent() {
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.isOpaque = false

        // If you have section headers/footers, this helps too
        tableView.sectionHeaderTopPadding = 0
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        print("Continue tapped")
        
        // 1️⃣ Make sure the user selected something
        guard selectedIndex != nil else {
            print("No app selected")
            return
        }
        
        // 2️⃣ SAVE the selected app
        saveSelectedApps()
        
        // 3️⃣ Navigate forward
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InstructionsVC")
        
        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    
    private func saveSelectedApps() {
        guard let selectedIndex else { return }
        
        let selectedApp = options[selectedIndex]
        UserDefaults.standard.set([selectedApp], forKey: "blocked_apps")
    }
    
    
}

extension ChooseAppsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        
        cell.textLabel?.text = options[indexPath.row]
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.isOpaque = false
        
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .default
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let oldSelectedIndex = selectedIndex
        selectedIndex = indexPath.row
        
        var indexPathsToReload: [IndexPath] = [indexPath]
        
        if let old = oldSelectedIndex, old != indexPath.row {
            indexPathsToReload.append(IndexPath(row: old, section: 0))
        }
        
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        
        let selectedValue = options[indexPath.row]
        print("Selected:", selectedValue)
    }
    
}

