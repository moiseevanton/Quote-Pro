//
//  QuoteBuilderViewController.swift
//  Quote Pro
//
//  Created by Anton Moiseev on 2016-06-08.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

import UIKit

protocol QBDelegate {
    func addQ(quote: Quote)
}

class QuoteBuilderViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var quoteButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    var listOfPhotos: NSMutableArray = []
    var quote: Quote?
    var quoteView: QuoteView!
    var firstLoad: Bool = true
    var qbdelegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Quote builder"
        
        // set up buttons
        setUpButtons()
        
        if let objects = NSBundle.mainBundle().loadNibNamed("QuoteView", owner: nil, options: [:]),
            let quoteView = objects.first as? QuoteView
        {
            // set up view in view hierarchy
            quoteView.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(quoteView, atIndex: 0)
            quoteView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 1).active = true
            quoteView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 1).active = true
            quoteView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 1).active = true
            quoteView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 1).active = true
            self.quoteView = quoteView
            
            // create all the photo objects
            getIdsForPhotos()
        }
    }
    
    func setUpButtons() {
        quoteButton.addTarget(self, action: #selector(QuoteBuilderViewController.changeQuote), forControlEvents: .TouchUpInside)
        imageButton.addTarget(self, action: #selector(QuoteBuilderViewController.changePhoto) , forControlEvents: .TouchUpInside)
        saveButton.addTarget(self, action: #selector(QuoteBuilderViewController.saveQuote) , forControlEvents: .TouchUpInside)
    }
    
    func getIdsForPhotos() {
        let req = NSMutableURLRequest(URL: NSURL(string: "https://unsplash.it/list")!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, resp, err) in
            
            guard let data = data else {
                print("no data returned from server \(err)")
                return
            }
            
            guard let resp = resp as? NSHTTPURLResponse else {
                print("no response returned from server \(err)")
                return
            }
            
            guard let rawJson = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as! [NSDictionary] else {
                print("data returned is not json, or not valid")
                return
            }
            
            guard resp.statusCode == 200 else {
                print("an error occurred \(err)")
                return
            }
            
            // do something with the data returned (decode json, save to user defaults, etc.)
            for photo in rawJson {
                let newPhoto = Photo()
                let id = photo["id"] as! NSNumber
                newPhoto.id = id.integerValue
                self.listOfPhotos.addObject(newPhoto)
            }
            self.getRandomQuote()
        }
        task.resume()
    }
    
    func getRandomQuote() {
        let req = NSMutableURLRequest(URL: NSURL(string: "http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json")!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, resp, err) in
            
            guard (resp as! NSHTTPURLResponse).statusCode == 200 else {
                print("an error occurred \(err)")
                return
            }
            
            guard let data = data else {
                print("no data returned from server \(err)")
                return
            }
            
            guard let rawJson = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary else {
                print("data returned is not json, or not valid")
                return
            }
            
            // do something with the data returned (decode json, save to user defaults, etc.)
            print(rawJson["quoteText"] as! String)
            print(rawJson["quoteAuthor"] as! String)
            
            if self.firstLoad {
                self.quote = Quote(body: rawJson["quoteText"] as? String, author: rawJson["quoteAuthor"] as? String)
                self.getRandomPhoto()
            } else {
                self.quote?.body = rawJson["quoteText"] as? String
                self.quote?.author = rawJson["quoteAuthor"] as? String
                dispatch_async(dispatch_get_main_queue(), { 
                    self.quoteView.setUpWithQuote(self.quote!)
                })
            }
        }
        task.resume()
    }
    
    func getRandomPhoto() {
        let randomId = Int(arc4random_uniform(UInt32(listOfPhotos.count)))
        let photo = listOfPhotos[randomId] as! Photo
        
        let req = NSMutableURLRequest(URL: NSURL(string: "https://unsplash.it/400/600?image=\(randomId)")!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, resp, err) in
            
            guard let data = data else {
                print("no data returned from server \(err)")
                return
            }
            
            guard let resp = resp as? NSHTTPURLResponse else {
                print("no response returned from server \(err)")
                return
            }
            
            guard resp.statusCode == 200 else {
                print("an error occurred \(err)")
                return
            }
            
            // do something with the data returned (decode json, save to user defaults, etc.)
            photo.image = UIImage(data: data)
            print(photo)
            self.quote?.photo = photo
            
            if self.firstLoad {
                self.firstLoad = false
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.quoteView?.setUpWithQuote(self.quote!)
            })
        }
        task.resume()
    }
    
    func changeQuote() {
        let currentPhoto = self.quote?.photo
        self.quote = Quote(body: nil, author: nil)
        self.quote?.photo = currentPhoto
        getRandomQuote()
    }
    
    func changePhoto() {
        getRandomPhoto()
    }
    
    func saveQuote() {
        self.qbdelegate!.addQ(self.quote!)
    }
}
