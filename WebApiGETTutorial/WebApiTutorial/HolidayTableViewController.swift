//
//  HolidayTableViewController.swift
//  WebApiTutorial
//
//  Created by Hasan on 21/10/2019.
//  Copyright © 2019 Hasan. All rights reserved.
//

import Foundation
import UIKit

class HolidayTableViewController: UITableViewController {


    @IBOutlet weak var searchBar: UISearchBar!

    var listOfHolidays = [HolidayDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfHolidays.count) Holidays found"
            }
        }
    }
    //array full of holiday detail objects
    // we use didset to reload data everytime we get new information and pass to this array

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfHolidays.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let holiday = listOfHolidays[indexPath.row]
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.date.iso //need date in iso format as specified in the api and so you set iso as string in your struct in the data model

        return cell
    }

}

extension HolidayTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let searchBarText = searchBar.text else {return}

        let holidayRequest = HolidayRequest(countryCode: searchBarText)
        holidayRequest.getHolidays { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let holidays):
                self?.listOfHolidays = holidays
                break

            }
        }
    }
}

// in the above extension we check if text exists in the search bar, we then use our struct holiday request to initialize it with a country code which comes from the search bar.

// we then use the holiday request object to call the function getHolidays. Set it as a closure as it takes in parameters and use weak self so it doesnt retain in cycle.

// we can then use a switch case for the result types. For success, we set an object holidays which gets all the holidays and we assign it to our listofholidays. So list ofholidays equals the holidays object that we get from our holiday request.
