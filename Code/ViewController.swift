//
//  ViewController.swift
//  TechTask
//
//  Created by Ilya Belyaev on 06/12/2019.
//  Copyright © 2019 BelApps. All rights reserved.
//

import UIKit

import SwiftyJSON

import Alamofire

class ViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addNewElements()
    }
    
    var items = [TaskItem]()
    
    let cellIdentifier = "TaskItem"
    
    var fetchMore = false
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell!
        
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = c
        }
        else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier:
            cellIdentifier)
        }
        
        cell.detailTextLabel!.text = items[indexPath.row].review
        
        cell.textLabel!.text = items[indexPath.row].title
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }


    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchMore {
                beginFetch()
            }
        }
    }
    
    
    
    func beginFetch() {
        fetchMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.addNewElements()
            self.tableView.reloadData()
        })
        
        fetchMore = false
    }
    
    
    
    func addNewElements() {
        
        let url = "https://en.wikipedia.org/w/api.php"
        
        let parameters: Parameters = [
                "action": "query",
                "format": "json",
                "prop": "extracts",
                "meta": "",
                "generator": "random",
                "utf8": 1,
                "formatversion": "2",
                "exsentences": "1",
                "exintro": 1,
                "explaintext": 1,
                "exsectionformat": "wiki",
                "grnnamespace": "0",
                "grnlimit": "15"
        ]
        
        Alamofire.SessionManager.default.request(url, method: .get, parameters: parameters).responseData { (resData) -> Void in
            
            switch (resData.result) {
            case let .success(resData):
                
                let swiftyJsonVar = JSON(resData)
                
                let names = swiftyJsonVar["query"]["pages"].arrayValue.map{$0["title"].stringValue}
                
                let reviews = swiftyJsonVar["query"]["pages"].arrayValue.map{$0["extract"].stringValue}
                
                for count in 0..<names.count {
                    self.items.append(TaskItem(names[count],reviews[count]))
                }
                    
            case let .failure(error):
                print("Can't read data from Wikipedia\n")
                return
            }
        }
        
    }

}

