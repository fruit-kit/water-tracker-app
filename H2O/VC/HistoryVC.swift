//
//  HistoryVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 06.03.26.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var clearHistoryOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        let historyTableViewCell = UINib(nibName: "HistoryTableViewCell", bundle: Bundle.main)
        historyTableView.register(historyTableViewCell, forCellReuseIdentifier: "HistoryTableViewCell")
        
        clearHistoryOutlet.applyStyle(title: "Clear all history", normalColor: .systemPink, highlightedColor: .gray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DrinkManager.shared.loadHistory()
        historyTableView.reloadData()
    }
 
    @IBAction func clearHistoryAction(_ sender: UIButton) {
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            DrinkManager.shared.clearAllHistory()
            self.historyTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertConfirmation(title: "Clear all history?", message: "This will remove all entries and cannot be undone.", actions: [clearAction, cancelAction])
    }
    
    private func setupNavigation() {
        navigationItem.title = "History"
        navigationController?.title = "History"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension HistoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = indexPath.row
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            DrinkManager.shared.deleteDrinkEntry(at: index)
            self.historyTableView.reloadData()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension HistoryVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DrinkManager.shared.drinkEntrys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        cell.dateLabel.text = "Date: \(dateFormatter.string(from:DrinkManager.shared.drinkEntrys[indexPath.row].date))"
        cell.timeLabel.text = "Time: \(timeFormatter.string(from:DrinkManager.shared.drinkEntrys[indexPath.row].date))"
        cell.volumeLable.text = "Volume: \(DrinkManager.shared.drinkEntrys[indexPath.row].volume)ml"
        cell.typeLabel.text = "Type: \(DrinkManager.shared.drinkEntrys[indexPath.row].type)"
        return cell
    }
    
}
