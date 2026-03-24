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
        tableView.delegate = self
        tableView.dataSource = self
        
        let historyTableViewCell = UINib(nibName: "HistoryTableViewCell", bundle: Bundle.main)
        tableView.register(historyTableViewCell, forCellReuseIdentifier: "HistoryTableViewCell")
        
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
    
    // MARK: - Actions
 
    @IBAction func clearHistoryAction(_ sender: UIButton) {
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            DrinkManager.shared.clearAllHistory()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertConfirmation(title: "Clear history?", message: "This action can't be undone.", actions: [clearAction, cancelAction])
    }

}

// MARK: - Extensions

extension HistoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let drinkEntries = self.entries(for: indexPath.section)
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
            
            self.alertConfirmation(title: "Delete entry?", message: "This action can't be undone.", actions: [cancelAction, deleteAction])
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteContextualAction, editContextualAction])
    }
    
}

extension HistoryVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            let todayEntries = entries(for: 0)
            return todayEntries.count
        }
        
        let earlierEntries = entries(for: 1)
        return earlierEntries.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        if indexPath.section == 0 {
            let todayEntries = entries(for: 0)
            cell.dateLabel.text = "Date: \(dateFormatter.string(from: todayEntries[indexPath.row].date))"
            cell.timeLabel.text = "Time: \(timeFormatter.string(from: todayEntries[indexPath.row].date))"
            cell.volumeLable.text = "Volume: \(todayEntries[indexPath.row].volume)ml"
            cell.typeLabel.text = "Type: \(todayEntries[indexPath.row].type)"
            return cell
        }
        
        let earlierEntries = entries(for: 1)
        cell.dateLabel.text = "Date: \(dateFormatter.string(from: earlierEntries[indexPath.row].date))"
        cell.timeLabel.text = "Time: \(timeFormatter.string(from: earlierEntries[indexPath.row].date))"
        cell.volumeLable.text = "Volume: \(earlierEntries[indexPath.row].volume)ml"
        cell.typeLabel.text = "Type: \(earlierEntries[indexPath.row].type)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Today"
        }
        return "Earlier"
        
    }
    
    private func entries(for section: Int) -> [DrinkEntry] {
        
        if section == 0 {
            let todayEntries = DrinkManager.shared.drinkEntrys.filter { Calendar.current.isDateInToday($0.date) }
            return todayEntries
        }
        
        let earlierEntries = DrinkManager.shared.drinkEntrys.filter { !Calendar.current.isDateInToday($0.date) }
        return earlierEntries
        
    }
    
}

extension HistoryVC: EditDrinkDelegate {
    
    func didEditDrink() {
        tableView.reloadData()
    }
    
}
