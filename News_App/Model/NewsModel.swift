//
//  NewsModel.swift
//  News_App
//
//  Created by Pushpendra on 28/07/24.
//

import Foundation

struct NewsModel {
    var image = ""
    var title = ""
    var description = ""
    var author = ""
    var time = ""
    var website = ""
    
    init(dicData: [String:Any]) {
        if let image = dicData["urlToImage"] as? String {
            self.image = image
        }
        
        if let title = dicData["title"] as? String {
            self.title = title
        }
        
        if let description = dicData["description"] as? String {
            self.description = description
        }
        
        if let author = dicData["author"] as? String {
            self.author = author
        }
        
        if let publishedAt = dicData["publishedAt"] as? String {
            self.time = publishedAt
        }
      
        
        if let web = dicData["url"] as? String {
            self.website = web
        }
        
    }
}
