//
//  ContentProvider.swift
//  MeetingTopShelf
//
//  Created by Lucas Costa  on 08/02/20.
//  Copyright © 2020 Bernardo Nunes. All rights reserved.
//

import TVServices

class ContentProvider: TVTopShelfContentProvider {

    override func loadTopShelfContent(completionHandler: @escaping (TVTopShelfContent?) -> Void) {
        // Fetch content and call completionHandler
        
        let item = TVTopShelfCarouselItem(identifier: "background")
        
        if let url = Bundle.main.url(forResource: "background1x", withExtension: "png") {
            item.setImageURL(url, for: .screenScale1x)
        }
        
        if let url = Bundle.main.url(forResource: "background2x", withExtension: "png") {
            item.setImageURL(url, for: .screenScale2x)
        }
        
        let content = TVTopShelfCarouselContent(style: .details, items: [item])
        
        completionHandler(content);
    }
    


}
