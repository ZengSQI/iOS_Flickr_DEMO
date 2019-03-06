//
//  Models.swift
//  iOS_Flickr_DEMO
//
//  Created by Steven Zeng on 2019/3/6.
//  Copyright © 2019 ZengSQi. All rights reserved.
//

import UIKit

struct Photo {
    var id:String
    var name:String
    var imgUrl:String
    
    init(id: String, name: String, imgUrl: String) {
        self.id = id
        self.name = name
        self.imgUrl = imgUrl
    }
    
    init?(dictionary : [String:String]) {
        guard let id = dictionary["id"],
            let name = dictionary["name"],
            let imgUrl = dictionary["imgUrl"]
            else { return nil }
        self.init(id: id, name: name, imgUrl: imgUrl)
    }
    
    var propertyListRepresentation : [String:String] {
        return ["id": id, "name": name, "imgUrl": imgUrl]
    }
}
