//
//  HistoryVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 06.03.26.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        let historyTableViewCell = UINib(nibName: "HistoryTableViewCell", bundle: Bundle.main)
        historyTableView.register(historyTableViewCell, forCellReuseIdentifier: "HistoryTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WaterManager.shared.loadHistory()
        historyTableView.reloadData()
    }
 
    private func setupNavigation() {
        navigationItem.title = "History"
        navigationController?.title = "History"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension HistoryVC: UITableViewDelegate { }

extension HistoryVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WaterManager.shared.drinkEntrys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        cell.dateLabel.text = "Date: \(dateFormatter.string(from:WaterManager.shared.drinkEntrys[indexPath.row].date))"
        cell.timeLabel.text = "Time: \(timeFormatter.string(from:WaterManager.shared.drinkEntrys[indexPath.row].date))"
        cell.volumeLable.text = "Volume: \(WaterManager.shared.drinkEntrys[indexPath.row].volume)ml"
        cell.typeLabel.text = "Type: \(WaterManager.shared.drinkEntrys[indexPath.row].type)"
        return cell
    }
    
}
