//
//  HolidaysTableViewController.swift
//  WeatherAPI
//
//  Created by Quang Kham on 22/05/2020.
//  Copyright © 2020 Quang Kham. All rights reserved.
//

import UIKit

class HolidaysTableViewController: UITableViewController {

    @IBOutlet var searchBar: UISearchBar!

    var listofHolidays = [HolidayDetail](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listofHolidays.count) holidays found"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listofHolidays.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let holiday = listofHolidays[indexPath.row]
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.iso
        

        return cell
    }
    
}

extension HolidaysTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text  else{
            return
        }
        var holidayRequest = HolidayRequest(countryCode: searchText)
        holidayRequest.getHolidays { result in
            switch result{
            case .failure( let error ):
                print(error)
            case .success(let holidays):
                self.listofHolidays = holidays
            }
        }
    }
    
    
}
