# ClimaCellAssiment
## The goal of this project is to build a simple and lightweight weather mobile application that provides the weather for all the capital cities of the world.
To build this app you will have to use Climacell Api Explore the api to understand which service suits you best.

Use https://restcountries.eu/rest/v2/all to get the needed data about all the capitals.

Required solution:
Create a mobile app that uses Climacell Api to get the weather data needed for a weather app
UI:
Markup : *Home Screen - Table with search-bar containing all the capitals. Each cell should contain the following :
                        *Name of the city and the country
                        *Picture of the flag of the country
                *City details screen - Small map showing where this city is & TableView with the weather for the next 5 days. Each cell should contain :
                        *Day
                        *Max and Min temperature
                        *Precipitation
Bonus points:
Small bonus
Caching - cache locally (use db or in memory) the responses from the api and use them when navigating between screens
Fahrenheit <-> Celsius - Add a button (right nav bar button) to toggle between the different metrics
Big bonus
MapView - In the main screen add a button switch to a map view. show a pin of every capital with the name. enable selection of capital and navigation to details screen.
In the city forecast screen : add a scrollable graph displaying minute by minute temperature for the next 6 hours. (Applicable only for cities in the US)

## App design:

<img src="https://github.com/HadarPur/ClimaCellAssiment/blob/master/ClimaCellApp.jpeg" />
