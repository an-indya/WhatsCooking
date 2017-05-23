//
//  PhotoNetworkManager.swift
//  Virtual-Tourist
//
//  Created by Anindya Sengupta on 5/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import CoreLocation

struct MealImage {
    var mealId: String
    var thumbnailURL: String
}

struct ItemIngredient {
    var name: String
    var measure: String
}

class MealNetworkManager: NSObject {

    class func getRandomMeals(completion: @escaping () -> Void) {
        var urlComponents = URLComponents()
        let url = URL(string: URLs.BaseURL)!
        urlComponents.scheme = url.scheme
        urlComponents.host = url.host
        urlComponents.path = Endpoints.randomListPath

        if let url = urlComponents.url {
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = methodName.GET.rawValue

            let task = session.dataTask(with: request) {
                (data, response, error) in
                guard let _:Data = data, let _:URLResponse = response, error == nil else {
                    print("error: \(String(describing: error?.localizedDescription))")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: networkNotificationKey), object: error?.localizedDescription)
                    completion()
                    return
                }
                do {
                    let responseJson  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        parse(json: responseJson, completion: { _ in
                            completion()
                            UserDefaults.standard.set(false, forKey: Keys.kIsFirstLaunch)
                        })
                } catch {
                    print("Error: \(error.localizedDescription)")
                    completion()
                }
            }
            task.resume()
        }
    }

    class func getFeaturedMeal(completion: @escaping ([Meal]?) -> Void) {
        var urlComponents = URLComponents()
        let url = URL(string: URLs.BaseURL)!
        urlComponents.scheme = url.scheme
        urlComponents.host = url.host
        urlComponents.path = Endpoints.randomMealPath

        if let url = urlComponents.url {
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = methodName.GET.rawValue

            let task = session.dataTask(with: request) {
                (data, response, error) in
                guard let _:Data = data, let _:URLResponse = response, error == nil else {                    
                    completion(nil)
                    return
                }
                do {
                    let responseJson  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    parse(json: responseJson, completion: { meals in
                        completion(meals)
                    })
                } catch {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
            task.resume()
        }
    }



    private class func parse(json: Any, completion: @escaping ([Meal]?) -> Void) {
        if let dict = json as? [String: Any],
            let mealsDictArray = dict["meals"] as? [[String: Any]] {
            var meals = [Meal]()
            var thumbnails = [MealImage]()
            for mealsDict in mealsDictArray {

                if let mealId = mealsDict["idMeal"] as? String,
                    let title = mealsDict["strMeal"] as? String,
                    let instructions = mealsDict["strInstructions"] as? String,
                    let thumbnail = mealsDict["strMealThumb"] as? String {

                    let sourceURL = mealsDict["strSource"] as? String
                    thumbnails.append(MealImage(mealId: mealId, thumbnailURL: thumbnail))

                    let ingredients = parseIngredients(with: mealsDict)

                    DispatchQueue.main.async {
                        MealDataManager.insertMeal(with: mealId, title: title, instruction: instructions, thumbnail: nil, sourceURL: sourceURL ?? "", thumbURL: thumbnail, completion: { (meal) in
                            if let meal = meal {
                                for ingredient in ingredients {
                                    IngredientDataManager.insertIngredient(with: ingredient.name, measure: ingredient.measure, meal: meal)
                                }
                                meals.append(meal)
                                if meals.count == mealsDictArray.count {
                                    completion(meals)
                                }
                            }
                        })
                    }
                } else {
                    completion(nil)
                }
            }


            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.downloadImages(with: thumbnails)
            }
        }
    }

    private class func parseIngredients (with dict: [String: Any]) -> [ItemIngredient] {
        var items = [ItemIngredient]()
        var counter = 1
        while counter <= 20 {
            counter += 1
            let ingredientKey = "strIngredient\(counter)"
            let measureKey = "strMeasure\(counter)"

            if let name = dict[ingredientKey] as? String,
                let measure = dict[measureKey] as? String {
                if name.characters.count > 0 {
                    items.append(ItemIngredient(name: name, measure: measure))
                }
            }
        }
        return items
    }

    private class func downloadImages (with mealImages: [MealImage]) {
        for mealImage in mealImages {
            Downloader.load(url: URL(string: mealImage.thumbnailURL)!, completion: { data in
                if let data = data {
                    DispatchQueue.main.async {
                        MealDataManager.updateMeal(id: mealImage.mealId, with: data)
                    }
                }
            })
        }

    }
}




class Downloader {
    class func load(url: URL, completion: @escaping (Data?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = "GET"
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }

                do {
                    let data = try Data(contentsOf: tempLocalUrl)
                    completion(data)
                } catch {
                    print("error converting data file \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                print("Failure: \(String(describing: error?.localizedDescription))")
                completion(nil)
            }
        }
        task.resume()
    }
}
