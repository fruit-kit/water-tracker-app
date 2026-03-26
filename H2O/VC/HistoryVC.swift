//
//  HistoryVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 06.03.26.
//

import UIKit

class HistoryVC: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearHistoryOutlet: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupTableViewCell()
        clearHistoryOutlet.applyStyle(title: "Clear all history", normalColor: .systemPink, highlightedColor: .gray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DrinkManager.shared.loadHistory()
        tableView.reloadData()
    }
    
    // MARK: - Methods
    
    private func setupNavigation() {
        navigationItem.title = "History"
        navigationController?.title = "History"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupTableViewCell() {
        let historyTableViewCell = UINib(nibName: "HistoryTableViewCell", bundle: Bundle.main)
        tableView.register(historyTableViewCell, forCellReuseIdentifier: "HistoryTableViewCell")
    }
    
    // MARK: - Actions
 
    @IBAction func clearHistoryAction(_ sender: UIButton) {
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            DrinkManager.shared.clearAllHistory()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        showAlert(title: "Clear history?", message: "This action can't be undone.", actions: [clearAction, cancelAction])
    }

}

// MARK: - Extensions

extension HistoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let drinkEntries = DrinkManager.shared.entries(for: indexPath.section)
        let drinkEntry = drinkEntries[indexPath.row]
        
        let editContextualAction = UIContextualAction(style: .normal, title: "Edit") { _ , _, completion in
            
            let addDrinkVC = AddDrinkVC(nibName: "AddDrinkVC", bundle: Bundle.main)
            
            if let realIndex = DrinkManager.shared.drinkEntrys.firstIndex(where: { $0.id == drinkEntry.id }) {
                
                addDrinkVC.presentVolume = drinkEntry.volume
                addDrinkVC.selectedDrink = drinkEntry.type
                
                addDrinkVC.mode = .edit(index: realIndex)
                addDrinkVC.delegateHistoryVC = self
                
                self.present(addDrinkVC, animated: true)
                completion(true)
            } else {
                completion(false)
            }

        }
        
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                
                if let realIndex = DrinkManager.shared.drinkEntrys.firstIndex(where: { $0.id == drinkEntry.id }) {
                    DrinkManager.shared.deleteDrinkEntry(at: realIndex)
                }
                
                self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            self.showAlert(title: "Delete entry?", message: "This action can't be undone.", actions: [cancelAction, deleteAction])
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteContextualAction, editContextualAction])
    }
    
}

extension HistoryVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DrinkManager.shared.entries(for: section).count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let drinkEntries = DrinkManager.shared.entries(for: indexPath.section)
        let entry = drinkEntries[indexPath.row]
        
            cell.dateLabel.text = "Date: \(dateFormatter.string(from: entry.date))"
            cell.timeLabel.text = "Time: \(timeFormatter.string(from: entry.date))"
            cell.volumeLable.text = "Volume: \(entry.volume)ml"
            cell.typeLabel.text = "Type: \(entry.type)"
            return cell
    
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Today"
        }
        
        if section == 1 {
            return "Yesterday"
        }
        
        return "Earlier"
        
    }
    
}

extension HistoryVC: EditDrinkDelegate {
    
    func didEditDrink() {
        tableView.reloadData()
    }
    
}
