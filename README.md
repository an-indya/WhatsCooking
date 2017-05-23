# WhatsCooking
This application is a testimony to one of the most basic needs of a human being - food, which - through the advancement of civilization and culture - has been much more than a need, but has transcended to the level of art. 

## Functionality
The app, when launched, pulls in 10 random recipes from http://www.themealdb.com and one featured recipe. The recipes are downloaded and saved in database. When the user taps on "Load More" button, another 10 recipes are downloaded and added to the view. 

### Meal Browser screen

1. This is the first screen the user views when launching the app.
2. Shows a featured meal at the top. Tapping on "Get Recipe" button shows the recipe details. When internet connection is not available, the app shows a random recipe as featured from the already downloaded meal
3. A collection of meals is displayed at the bottom. They are loaded from database unless this is the first launch
4. The images of the meals, if available in database, are shown. Else they are loaded from the web
5. If the user SHAKES the phone, more meals are downloaded
6. If the user taps the "Load More" button, more meals are downloaded

### Recipe Details Screen

1. When the user taps on any meal or at the button in the featured meal, this screen is displayed
2. This screen shows the picture of the meal, ingredients and steps in a grouped tableview
3. The ingredients has checkboxes so that the user can can check them off when shopping
4. The checked states are persistent too - so that the user can browse other recipes and then come back to see the checked boxes

### Network Availability

Here's how the app handles network failure

1. When a download of meals fails, it shows an alert
2. In the absense of network connections, if this is not the first launch, the app shows downloaded meals
3. As for the featured meal, the app chooses one meal randomly. (If the number of recipes are less than the generated random number, it does not generate other random numbers but shows the first meal as featured)


