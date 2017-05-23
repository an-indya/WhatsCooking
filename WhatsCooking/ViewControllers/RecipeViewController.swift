//
//  RecipeViewController.swift
//  WhatsCooking
//
//  Created by Anindya Sengupta on 5/18/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

enum CellIdentifier: String {
    case bannerCell
    case ingredientsCell
    case instructionsCell
}

class RecipeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var meal: Meal!
    var ingredients: [Ingredient]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredients = Array(meal.ingredients!)
        tableView.reloadData()
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2 {
            return 1
        } else {
            if let ingredients = meal.ingredients {
                 return ingredients.count
            } else {
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 30
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        let label = UILabel(frame: CGRect(x: 10, y: -5, width: UIScreen.main.bounds.width, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.7414829135, green: 0.2057717144, blue: 0.225273788, alpha: 1)
        if section == 1 {
            label.text = "INGREDIENTS"
        } else if section == 2 {
            label.text = "STEPS"
        }
        view.addSubview(label)
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else if indexPath.section == 1 {
            let nameText = ingredients[indexPath.row].name
            let measureText = ingredients[indexPath.row].measure
            let nameHeight = max(getCellHeight(for: nameText), 44)
            let measureHeight = max(getCellHeight(for: measureText), 44)
            return max(nameHeight, measureHeight)
        } else {
            let text = meal.instruction
            return getCellHeight(for: text)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            let bannerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.bannerCell.rawValue, for: indexPath) as! BannerTableViewCell
            bannerCell.configure(with: meal)
            cell = bannerCell
        } else if indexPath.section == 2 {
            let instructionCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.instructionsCell.rawValue, for: indexPath) as! InstructionsTableViewCell
            instructionCell.instructionsLabel.text = meal.instruction
            cell = instructionCell
        } else {
            let ingredientsCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ingredientsCell.rawValue, for: indexPath) as! IngredientsTableViewCell
            let ingredient = ingredients[indexPath.row]
            ingredientsCell.ingredientTitle.text = ingredient.name
            ingredientsCell.measure.text = ingredient.measure
            ingredientsCell.ingredientImage.image = ingredient.checked ? #imageLiteral(resourceName: "complete") : #imageLiteral(resourceName: "notcomplete")
            cell = ingredientsCell
        }
        return cell
    }

    func getCellHeight(for text: String) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? IngredientsTableViewCell {
                let ingredient = ingredients[indexPath.row]
                ingredient.checked = !ingredient.checked
                IngredientDataManager.updateIngredient(ingredient: ingredient)
                cell.ingredientImage.image = ingredient.checked ? #imageLiteral(resourceName: "complete") : #imageLiteral(resourceName: "notcomplete")
            }
        }
    }
}
