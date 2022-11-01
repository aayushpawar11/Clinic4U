//
//  FetchClinics.swift
//  NearestClinic
//
//  Created by Aayush Pawar on 10/27/22.
//

import Foundation
import SwiftUI
import MapKit

func collectLattitudeLongitude(_ zipCode : String) -> [GeoLocation] {
    let restString : String = "https://maps.googleapis.com/maps/api/geocode/json?address=" + zipCode + "&key=" + api_key
    let url: URL = URL(string: restString)!

    let sem = DispatchSemaphore.init(value: 0)
    var locations : [GeoLocation] = []
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error in
        defer { sem.signal() }
        if let data = data, let _ = String(data: data, encoding: .utf8){
            do {
                let decoder = JSONDecoder()
                let geoLocation : GeoLocationResult = try decoder.decode(GeoLocationResult.self, from: data)
                locations = geoLocation.results
            } catch {
                fatalError("Error parsing JSON data")
            }
        }
    }
    task.resume()
    sem.wait()
    return locations;
}


func loadFromURL(_ zipCode : String) -> [Clinic] {
    var clinics : [Clinic] = []

    let locations : [GeoLocation] = collectLattitudeLongitude(zipCode)
    if locations.count == 0 {
        return []
    }

    let location : GeoLocation = locations[0]

    let lat : String = String(location.geometry.location.lat)
    let lng : String = String(location.geometry.location.lng)

    // TODO: Update radius to be autocalculated
    let restString : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + lat + "%2C" + lng + "&radius=15000&type=health&keyword=free%20clinic&key=" + api_key
    let url: URL = URL(string: restString)!

    let sem = DispatchSemaphore.init(value: 0)
    
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error in
        defer { sem.signal() }
        if let data = data, let _ = String(data: data, encoding: .utf8){
            do {
                let decoder = JSONDecoder()
                let googleMapsSearch : GoogleMapRestResult = try decoder.decode(GoogleMapRestResult.self, from: data)
                clinics = googleMapsSearch.results
            } catch {
                fatalError("Error parsing JSON data")
            }
        }
    }
    task.resume()
    sem.wait()
    return clinics
}

func filterClinics(_ clinics : [Clinic]) -> [Clinic] {
    let filteredClinics = clinics.filter { $0.name != "MinuteClinic" }
    return filteredClinics
}


func getDetailedInfoOfClinic(_ placeID : String) -> DetailedClinic {
    let restString : String = "https://maps.googleapis.com/maps/api/place/details/json?place_id=" + placeID + "&key=" + api_key
    let url: URL = URL(string: restString)!

    let sem = DispatchSemaphore.init(value: 0)
    var detailedInfo : [DetailedClinicWithResult] = []
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error in
        defer { sem.signal() }
        if let data = data, let _ = String(data: data, encoding: .utf8){
            do {
                let decoder = JSONDecoder()
                detailedInfo.append(try decoder.decode(DetailedClinicWithResult.self, from: data))
            } catch {
                fatalError("Error parsing JSON data: \(error)")
            }
        }
    }
    task.resume()
    sem.wait()
    return detailedInfo[0].result
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func callNumber(phoneNumber: String) {
    let phone = "tel://" + phoneNumber.filter { !" ".contains($0) }
    guard let url = URL(string: phone) else { return }
    UIApplication.shared.open(url)
}

func openAppleMaps(coordinate: CLLocationCoordinate2D) {
    guard let url = URL(string:"http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else { return }
    UIApplication.shared.open(url)
}
