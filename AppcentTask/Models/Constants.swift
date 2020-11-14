//
//  Constants.swift
//  AppcentTask
//
//  Created by Said Çankıran on 13.11.2020.
//

import Foundation

class Constants {
    static let shared = Constants()
    
    let gameCellProperty = "GameCell"
    let toGameDetail = "toGameDetail"
    
    let requestURL = "https://rawg-video-games-database.p.rapidapi.com/games"
    let requestHeaders = [
        "x-rapidapi-key": "cf214c99d5msh961c518eb08c4dcp151e0djsn8751bad2af77",
        "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
    ]
    
}
