//
//  ViewController.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit

class HobbiesViewController: UIViewController {
    
    enum EntryMode {
        case onboarding
        case editFromOpeningPage
    }
    
    var entryMode: EntryMode = .onboarding
    
    @IBOutlet weak var tableView: UITableView!
    
    private var hobbies: [Task] = []
    private let storageKey = "hobbies_list_v2"
    
    private enum Section: Int, CaseIterable {
        case hobbies = 0
        case addRow = 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        makeTableTransparent()
        loadHobbies()
        
        configureMoveOnFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyAppGradient()
        view.updateAppGradientFrame() // add this helper in your extension
    }

    
    private func makeTableTransparent() {
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.isOpaque = false

        // If you have section headers/footers, this helps too
        tableView.sectionHeaderTopPadding = 0
    }

    
    // MARK: - Footer (Continue button)
    private func configureMoveOnFooter() {
        let footerHeight: CGFloat = 120

        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: footerHeight))
        footer.backgroundColor = .clear

        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)

        // --- STYLE (tinted look) ---
        // Use asset colors
        let primary = UIColor(named: "Primary") ?? .label
        let background = UIColor(named: "Background") ?? .secondarySystemBackground

        // iOS 15+ recommended styling
        var config = UIButton.Configuration.tinted()
        config.title = "Continue"
        config.baseForegroundColor = .heading        // text color
        config.baseBackgroundColor = .background        // tinted background
        config.cornerStyle = .capsule                 // pill shape
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 22, bottom: 14, trailing: 22)

        button.configuration = config

        // Optional: font weight similar to your screenshot
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        // Optional: remove any border you previously had
        button.layer.borderWidth = 0

        button.addTarget(self, action: #selector(moveOnTapped), for: .touchUpInside)

        footer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: -16)
        ])

        tableView.tableFooterView = footer
    }

    
    @objc private func moveOnTapped() {
        print("🔘 Move On tapped")
        print("📍 entryMode:", entryMode)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chooseAppsVC = storyboard.instantiateViewController(withIdentifier: "ChooseAppsVC")

        print("📦 chooseAppsVC type:", type(of: chooseAppsVC))
        print("🧭 navigationController:", navigationController as Any)

        if let nav = navigationController {
            print("➡️ PUSHING ChooseAppsVC")
            nav.pushViewController(chooseAppsVC, animated: true)
        } else {
            print("❌ navigationController is NIL — PRESENTING instead")
            chooseAppsVC.modalPresentationStyle = .fullScreen
            present(chooseAppsVC, animated: true)
        }
    }

    
    
    // MARK: - Add/Edit Alerts
    
    private enum AlertMode {
        case add
        case edit(index: Int)
    }
    
    private func deleteHobby(at index: Int) {
        hobbies.remove(at: index)
        saveHobbies()
        RecommendationManager.clearRecommendation()
        tableView.deleteRows(at: [IndexPath(row: index, section: Section.hobbies.rawValue)], with: .automatic)
    }
    
    // MARK: - Local Persistence
    
    private func saveHobbies() {
        do {
            let data = try JSONEncoder().encode(hobbies)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save hobbies:", error)
        }
    }
    
    private func loadHobbies() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            hobbies = [
                Task(title: "Drawing", category: .hobby),
                Task(title: "Homework", category: .school)
            ]
            
            saveHobbies()
            return
        }
        
        do {
            hobbies = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("Failed to load hobbies:", error)
            hobbies = []
        }
    }

    
    private func presentAddEdit(existing: Task? = nil, index: Int? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let addVC = storyboard.instantiateViewController(withIdentifier: "AddActivityVC") as? AddActivityViewController else {
            return
        }

        addVC.existing = existing
        addVC.existingIndex = index

        addVC.onSave = { [weak self] newItem, existingIndex in
            guard let self else { return }

            if let existingIndex {
                self.hobbies[existingIndex] = newItem
            } else {
                self.hobbies.append(newItem)
            }

            self.saveHobbies()
            self.tableView.reloadData()
        }

        // ✅ Present as a bottom sheet with fixed height
        addVC.modalPresentationStyle = .pageSheet

        if let sheet = addVC.sheetPresentationController {
            // Choose a height that looks good (example: 320)
            sheet.detents = [
                .custom { _ in 320 }
            ]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 18
            sheet.largestUndimmedDetentIdentifier = .medium
        }

        present(addVC, animated: true)
    }

    
    
}

// MARK: - UITableViewDataSource

extension HobbiesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }
        
        switch sec {
        case .hobbies:
            return hobbies.count
        case .addRow:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sec = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch sec {
        case .hobbies:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HobbyCell", for: indexPath)
            let item = hobbies[indexPath.row]

            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.category.rawValue

            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
            let icon = UIImage(systemName: item.category.symbolName)?
                .applyingSymbolConfiguration(config)

            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.isOpaque = false

            cell.imageView?.image = icon
            cell.imageView?.tintColor = .primary
            cell.imageView?.contentMode = .scaleAspectFit
            

            return cell
            
        case .addRow:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.isOpaque = false

            cell.textLabel?.text = "+ Add Activity"
            cell.accessoryType = .none
            cell.selectionStyle = .default
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension HobbiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let sec = Section(rawValue: indexPath.section) else { return }
        
        switch sec {
        case .hobbies:
            presentAddEdit(existing: hobbies[indexPath.row], index: indexPath.row)
            
        case .addRow:
            presentAddEdit()
            
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        guard indexPath.section == Section.hobbies.rawValue else { return nil }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, done in
            self.deleteHobby(at: indexPath.row)
            done(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, done in
            self.presentAddEdit(existing: self.hobbies[indexPath.row], index: indexPath.row)
            done(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

