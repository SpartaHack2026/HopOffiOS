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
        
        loadHobbies()
        
        configureMoveOnFooter()
    }
    
    // MARK: - Footer (Continue button)
    
    private func configureMoveOnFooter() {
        let footerHeight: CGFloat = 100
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: footerHeight))
        footer.backgroundColor = .clear
        
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        
        button.addTarget(self, action: #selector(moveOnTapped), for: .touchUpInside)
        
        footer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: -16)
        ])
        
        tableView.tableFooterView = footer
    }
    
//    @objc private func moveOnTapped() {
//        switch entryMode {
//            
//        case .onboarding:
//            // ✅ CONTINUE ONBOARDING
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let chooseAppsVC = storyboard.instantiateViewController(withIdentifier: "ChooseAppsVC")
//            
//            navigationController?.pushViewController(chooseAppsVC, animated: true)
//            
//        case .editFromOpeningPage:
//            // ✅ RETURN BACK TO OPENING PAGE
//            navigationController?.popViewController(animated: true)
//        }
//    }
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
        
        addVC.modalPresentationStyle = .formSheet
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
            
            return cell
            
        case .addRow:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
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

