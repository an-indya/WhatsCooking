//
//  BannerTableViewCell.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    @IBOutlet weak var bannerImageView: AsyncImageView!
}

extension BannerTableViewCell {
    func configure (with meal: Meal) {
        if let thumbnail = meal.thumbnail {
            bannerImageView.image = UIImage(data: thumbnail)
        } else {
            bannerImageView.imageURL = URL(string: meal.thumbURL)
        }
    }
}
