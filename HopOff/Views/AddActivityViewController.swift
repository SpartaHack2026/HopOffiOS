//
//  ViewController.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit

class AddActivityViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    var existing: Task?
    var existingIndex: Int?
    
    var onSave: ((Task, Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = existing == nil ? "Add Activity" : "Edit Activity"
        
        if let existing {
            nameTextField.text = existing.title
            categorySegment.selectedSegmentIndex = indexForCategory(existing.category)
        } else {
            categorySegment.selectedSegmentIndex = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyAppGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named: "Primary")
    }

    
    @IBAction func saveTapped(_ sender: UIButton) {
        let name = (nameTextField.text ?? "")
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        guard !name.isEmpty else { return }
        
        let category = categoryForIndex(categorySegment.selectedSegmentIndex)
        let newItem = Task(title: name, category: category)
        
        onSave?(newItem, existingIndex)
        dismiss(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func categoryForIndex(_ index: Int) -> ActivityCategory {
        switch index {
        case 0: return .hobby
        case 1: return .school
        case 2: return .chores
        default: return .exercise
        }
    }
    
    private func indexForCategory(_ category: ActivityCategory) -> Int {
        switch category {
        case .hobby: return 0
        case .school: return 1
        case .chores: return 2
        case .exercise: return 3
        }
    }
    
}

