//
//  Quote.swift
//  Quote Pro
//
//  Created by Anton Moiseev on 2016-06-08.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

import Foundation

class Quote: NSObject {
    var body: String?
    var author: String?
    var photo: Photo?
    
    init(body: String?, author: String?) {
        self.body = body
        self.author = author
    }
}