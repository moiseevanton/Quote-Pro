//
//  QuoteView.swift
//  Quote Pro
//
//  Created by Anton Moiseev on 2016-06-08.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

import UIKit

class QuoteView: UIView {

    // MARK: Properties
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setUpWithQuote(quote: Quote) {
        quoteLabel.text = quote.body
        authorLabel.text = quote.author
        imageView.image = quote.photo?.image
    }
    
}
