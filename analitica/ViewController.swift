//
//  ViewController.swift
//  analitica
//
//  Created by Yasin AKCA on 29.09.2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        parseTimeZone(abbreviation: "Europe/Istanbul")
                
        //        let geoItem = callGeoLocation()
        //        callAstroDetailApi(geoItem: geoItem)
    }

    

}


func callAstroDetailApi(geoItem: GeoItem) {
    let adr = AstroDetailRequest(day: 12, month: 3, year: 1992, hour: 2, min: 23, lat: geoItem.latitude!, lon: geoItem.longitude!, tzone: 5.5)

    //
    //func callAstroDetailApi() {
    //    let adr = AstroDetailRequest(day: 12, month: 3, year: 1992, hour: 2, min: 23, lat: 34.54, lon: 45.23, tzone: 5.5)
    let encoder = JSONEncoder()
    let data = try! encoder.encode(adr)
    let string = String(data: data, encoding: .utf8)!

    let url = URL(string: "https://json.astrologyapi.com/v1/astro_details")

    guard let reqUrl = url else { fatalError() }
    var request = URLRequest(url: reqUrl)
    request.httpMethod = "POST"

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Base " + stringToBase64(str:"614345:184b1272d665ad7bef5e95daf0128169"), forHTTPHeaderField: "Authorization")

    request.httpBody = string.data(using: String.Encoding.utf8);


    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            return
        }

        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
        }
    }
    task.resume()
}

func callGeoLocation() {
func callGeoLocation() -> GeoItem {
    let gr = GeoRequest(place: "Sams", maxRows: 6)

    let encoder = JSONEncoder()
    let data = try! encoder.encode(gr)
    let string = String(data: data, encoding: .utf8)!

    let url = URL(string: "https://json.astrologyapi.com/v1/geo_details")

    guard let reqUrl = url else { fatalError() }
    var request = URLRequest(url: reqUrl)
    request.httpMethod = "POST"

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Base " + stringToBase64(str:"614345:184b1272d665ad7bef5e95daf0128169"), forHTTPHeaderField: "Authorization")

    request.httpBody = string.data(using: String.Encoding.utf8);
    var geoItem: GeoItem
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            return
        }

        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
        }


        do{
            let geoResponse = try JSONDecoder().decode(GeoResponse.self, from: data!)
            print("Response data:\n \(geoResponse)")
            geoItem = geoResponse.geonames[2]
        }catch let jsonErr{
            print(jsonErr)
        }
    }
    task.resume()

    return geoItem

}


func stringToBase64(str: String) -> String{
    let utf8str = str.data(using: .utf8)
    let fan = (utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)))!
    return fan
}

func parseTimeZone(abbreviation: String) {
   let tz  =  TimeZone.init(identifier: abbreviation)
//    let tz = TimeZone.init(abbreviation: abbreviation)
//    TimeZone.
    print("Response data string:\n \(tz!)")
}

struct AstroDetailRequest: Codable {
    var day: Int
    var month: Int
    var year: Int
    var hour: Int
    var min: Int
    var lat: Double
    var lon: Double
    var tzone: Double
}

struct GeoRequest: Codable {
    var place: String
    var maxRows: Int
}

struct GeoResponse: Codable {
    var geonames: [GeoItem]
}

struct GeoItem: Codable {
    var place_name:  String
    var latitude: Double
    var longitude: Double
    var timezone_id: String
    var country_code: String
}

}
