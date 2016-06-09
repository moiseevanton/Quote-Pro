//
//  ViewController.swift
//  Quote Pro
//
//  Created by Anton Moiseev on 2016-06-08.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, QBDelegate {
    
    var objects: NSMutableArray = []

    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Quotes"
        
        // make this view controller both the data source and the delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // set row height
        self.tableView.rowHeight = 80
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addQuoteSegue" {
            let qbvc = segue.destinationViewController as! QuoteBuilderViewController
            qbvc.qbdelegate = self
            
        }
    }
    
    func addQ(quote: Quote) {
        objects.addObject(quote)
    }
}

extension ViewController: UITableViewDataSource {
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomCell
        cell.upperCellLabel.text = (objects[indexPath.row] as? Quote)?.body
        cell.cellLabel.text = (objects[indexPath.row] as? Quote)?.author
        cell.cellImageView.image = (objects[indexPath.row] as? Quote)?.photo?.image
        return cell
    }
}

