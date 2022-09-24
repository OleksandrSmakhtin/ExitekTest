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
    var mobiles = [Mobile]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        mobiles = Array(mobileData.getAll())
        print("-----------Mobiles------------")
        print(mobiles)
        print("------------------------------")
    }
    var temp = [
        Temp(model: "iPhone 12", imei: "5645763456724576245"),
        Temp(model: "iPhone 13", imei: "2342453456724576245"),
        Temp(model: "iPhone 14", imei: "2342453456724576245"),
        Temp(model: "iPhone 12", imei: "5645763456724576245"),
        Temp(model: "iPhone 13", imei: "2342453456724576245"),
        Temp(model: "iPhone 14", imei: "2342453456724576245")
    ]
    
    
    func updateMobileTable() {
        mobiles = Array(mobileData.getAll())
        mobileTable.reloadData()
        print("-----------Mobiles------------")
        print(mobiles)
        print("------------------------------")
    }
    
    @objc func addBtnPressed() {
        
        var modelTextField = UITextField()
        var imeiTextField = UITextField()
        
        let alert = UIAlertController(title: "Add device", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let model = modelTextField.text, let imei = imeiTextField.text {
                
                let newDevice = Mobile(context: self.context)
                newDevice.model = modelTextField.text!
                newDevice.imei = imeiTextField.text!
                
                
                if self.mobileData.exists(newDevice) == true {
                    do {
                        try self.mobiles.append(self.mobileData.save(newDevice))
                        
                    } catch {
                        print("alert error")
                    }
                    self.updateMobileTable()
                }
                
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Model"
            modelTextField = alertTextField
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "IMEI"
            imeiTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func configureView() {
        let backgroundView = UIImageView(frame: view.bounds)
        backgroundView.image = UIImage(named: "background")
        backgroundView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundView, at: 0)
        
        let existButton = UIButton()
        existButton.setImage(UIImage(named: "exist"), for: .normal)
        view.addSubview(existButton)
        existButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(60)
        }
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "add"), for: .normal)
        addButton.addTarget(self, action: #selector(addBtnPressed), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.right.equalToSuperview().inset(15)
        }
        
        let searchBar = UISearchBar()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(45)
            make.left.equalTo(existButton.snp_rightMargin).inset(-14)
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


//MARK: - TableView DataSource & Delegate

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return temp.count
        return mobiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mobileCell") as! MobileTableCell
        //cell.configureCell(mobile: temp[indexPath.row])
        cell.configureCell(mobile: mobiles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            view.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 0)
            view.layer.cornerRadius = 15
            completionHandler(true)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 0)
        deleteAction.image = UIImage(named: "delete")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
}
