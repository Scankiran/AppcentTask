//
//  API.swift
//  AppcentTask
//
//  Created by Said Çankıran on 20.11.2020.
//

import Foundation
import Alamofire
class API {
    static let run = API()
    
    
    /// Fetch Games from API with Alamofire. And If fectch after first page, append data to situated data.
    func getGames(completionHandler:@escaping(_ data:Games?,_ error:Error?)->Void)  {
        AF.request(Constants.shared.requestURL, method: .get, parameters: nil, headers: HTTPHeaders.init(Constants.shared.requestHeaders), interceptor: nil, requestModifier: nil).response { (response) in
            if let data = response.data {
                do {
                    let data = try JSONDecoder.init().decode(Games.self, from: data)
                    completionHandler(data,nil)
                    
                }catch {
                    completionHandler(nil,error)
                }
            }
        }
    }
    
    /// Fetch Selected GameDetail from API with Alamofire. And If fectch after first page, append data to situated data
    func getGameDetail(gameID:Int,completionHandler:@escaping(_ gameDetail:GameDetail?,_ error:Error?)-> Void) {
        AF.request(Constants.shared.requestURL + "/\(gameID)", method: .get, parameters: nil, headers: HTTPHeaders.init(Constants.shared.requestHeaders), interceptor: nil, requestModifier: nil).response { (response) in
            if let data = response.data {
                do {
                    let details = try JSONDecoder.init().decode(GameDetail.self, from: data)
                    completionHandler(details,nil)
                }catch {
                    completionHandler(nil,error)
                }
            }
        }
    }
    
}
