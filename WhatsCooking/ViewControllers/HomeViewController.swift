//
//  HomeViewController.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/18/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, SegueHandler {

    @IBOutlet weak var featuredTitle: UILabel!
    @IBOutlet weak var topBannerImage: AsyncImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var featuredMeal: Meal!

    enum SegueIdentifier: String {
        case showRecipe = "showRecipe"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        populateMeals()
    }

    func populateMeals () {
        MealNetworkManager.getRandomMeals {
            DispatchQueue.main.async {
                self.setupCollectionView()
            }
        }
        MealNetworkManager.getFeaturedMeal {meals in
            if let meal = meals?.first {
                DispatchQueue.main.async {

                    if let imgData = meal.thumbnail,
                        let image = UIImage(data: imgData) {
                        self.topBannerImage.image =  image
                    } else {
                        self.topBannerImage.imageURL = URL(string: meal.thumbURL)!
                    }
                    self.featuredMeal = meal
                    self.featuredTitle.text = meal.title
                    self.featuredTitle.sizeToFit()
                }
            }
        }
    }

    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        DispatchQueue.main.async {
            MealDataManager.deleteAllMeals()
        }
        populateMeals()
    }

    
    @IBAction func didTapGetRecipe(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.showRecipe, sender: featuredMeal)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RecipeViewController,
            let meal = sender as? Meal {
            destination.meal = meal
            destination.title = meal.title
        }
    }


    // MARK: Private

    fileprivate var dataSource: CollectionViewDataSource<HomeViewController>!

    fileprivate func setupCollectionView() {
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        let request = Meal.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 10
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        guard let cv = collectionView else { fatalError("must have collection view") }
        dataSource = CollectionViewDataSource(collectionView: cv, cellIdentifier: "mealCell", fetchedResultsController: frc, delegate: self)
    }

}

extension HomeViewController: CollectionViewDataSourceDelegate {
    func configure(_ cell: MealCollectionViewCell, for object: Meal) {
        cell.configure(for: object)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = dataSource.objectAtIndexPath(indexPath)
        performSegue(withIdentifier: SegueIdentifier.showRecipe, sender: meal)
    }
}
