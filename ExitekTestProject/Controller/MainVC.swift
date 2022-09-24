//
//  ViewController.swift
//  ExitekTestProject
//
//  Created by Oleksandr Smakhtin on 23.09.2022.
//

import UIKit
import SnapKit
import CoreData
class MainVC: UIViewController {

    let mobileData = MobilesData()
    let mobileTable = UITableView()
    let searchBar = UISearchBar()
    var mobiles = [Mobile]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureView()
        mobiles = Array(mobileData.getAll())
    }

    @objc func addBtnPressed() {
        addDevice()
    }
}


//MARK: - TableView DataSource & Delegate
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func updateMobileTable() {
        mobiles = Array(mobileData.getAll())
        mobileTable.reloadData()
    }
    
    // numbers of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mobiles.count
    }
    
    // configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mobileCell") as! MobileTableCell
        cell.configureCell(mobile: mobiles[indexPath.row])
        return cell
    }
    
    // enable row editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // add table view action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // configure delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            view.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 0)
            view.layer.cornerRadius = 15
            
            let mobile = self.mobiles[indexPath.row]
            try! self.mobileData.delete(mobile)
            self.mobiles.remove(at: indexPath.row)
            self.mobileTable.deleteRows(at: [indexPath], with: .left)
            try! self.mobileData.save(mobile)
            self.updateMobileTable()
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 0)
        deleteAction.image = UIImage(named: "delete")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
}

//MARK: - SearchBar Delegate
extension MainVC: UISearchBarDelegate {
    
    // search bar search by input
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let device = mobileData.findByImei(searchBar.text!) {
            mobiles.removeAll()
            mobiles.append(device)
            mobileTable.reloadData()
        } else {
            addAlert(alertTitle: "ERROR", alertMessage: "Type full IMEI or try again")
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }

        
    }
    
    // hide keyboard if there is no text in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            updateMobileTable()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

//MARK: - Alert Controllers
extension MainVC {
    
    // add new device alert
    func addDevice() {
        var modelTextField = UITextField()
        var imeiTextField = UITextField()
        
        let alert = UIAlertController(title: "Add device", message: "", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Add", style: .default) { action in
            
            if let model = modelTextField.text, let imei = imeiTextField.text {
                
                if modelTextField.text != "" || imeiTextField.text != "" {
                    
                    let newDevice = Mobile(context: self.context)
                    newDevice.model = modelTextField.text!
                    newDevice.imei = imeiTextField.text!
                    
                    if !self.mobileData.exists(newDevice) {
                        do {
                            try self.mobiles.append(self.mobileData.save(newDevice))
                        } catch {
                        }
                        self.updateMobileTable()
                    } else {
                        try! self.mobileData.delete(newDevice)
                        self.addAlert(alertTitle: "ERROR", alertMessage: "Device with this IMEI already exists")
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Model"
            modelTextField = alertTextField
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "IMEI"
            imeiTextField = alertTextField
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    // add alert of specific title and message
    func addAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            print("ITEM ALREADY EXISTS")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - CONFIGURE VIEW
extension MainVC {
    
    func configureView() {
        
        // background image
        let backgroundView = UIImageView(frame: view.bounds)
        backgroundView.image = UIImage(named: "background")
        backgroundView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundView, at: 0)
        
        // add button
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "add"), for: .normal)
        addButton.addTarget(self, action: #selector(addBtnPressed), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.right.equalToSuperview().inset(15)
        }
        
        // searchBar
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.keyboardType = .numbersAndPunctuation
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(45)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(addButton.snp_leftMargin).inset(-14)
        }
        
        // table view
        view.addSubview(mobileTable)
        // set delegates
        setTableViewDelegates()
        // register cell
        mobileTable.register(MobileTableCell.self, forCellReuseIdentifier: "mobileCell")
        // settings
        mobileTable.separatorStyle = .none
        mobileTable.showsVerticalScrollIndicator = false
        mobileTable.rowHeight = 80
        mobileTable.backgroundColor = .clear
        // constraints
        mobileTable.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp_bottomMargin).offset(15)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
        func setTableViewDelegates() {
            mobileTable.delegate = self
            mobileTable.dataSource = self
        }
    }
}
