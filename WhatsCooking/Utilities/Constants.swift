//
//  Constants.swift
//  Virtual-Tourist
//
//  Created by Anindya Sengupta on 5/4/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

enum methodName: String {
    case GET
    case POST
    case PUT
}

struct URLs {
    static let BaseURL = "http://www.themealdb.com/api/json/v1/1"
}

struct Endpoints {
    static let common = "/api/json/v1/1"
    static let randomMealPath = common + "/random.php"
    static let lookupMealPath = common + "/lookup.php?i={id}"
    static let randomListPath = common + "/randomselection.php"
}

struct Keys {
    static let kIsFirstLaunch = "kIsFirstLaunch"
}

var documentsDirectory : String {
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let documentDirectoryPath:String = path[0]
    return documentDirectoryPath
}
