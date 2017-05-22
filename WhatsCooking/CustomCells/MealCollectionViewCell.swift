//
//  MealCollectionViewCell.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: AsyncImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

extension MealCollectionViewCell {
    func configure(for meal: Meal) {
        if let data = meal.thumbnail {
            imageView.image = UIImage(data: data)
        } else {
            imageView.imageURL = URL(string: meal.thumbURL)!
        }

        titleLabel.text = meal.title
    }
}
