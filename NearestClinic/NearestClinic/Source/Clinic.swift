//
//  Clinic.swift
//  NearestClinic
//
//  Created by Aayush Pawar on 10/27/22.
//

import Foundation
import SwiftUI
import CoreLocation


// to hold info about clinics from google maps search api
struct Clinic: Hashable, Codable {
    var name: String
    var rating: Float
    var vicinity: String

    var place_id : String
    var user_ratings_total: Int

    private var geometry: Geometry

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: geometry.location.lat,
            longitude: geometry.location.lng)
    }

    struct Geometry: Hashable, Codable {
        var location : Location

        struct Location : Hashable, Codable {
            var lat : Double
            var lng : Double
        }
    }
}

struct GoogleMapRestResult: Hashable, Codable {
    var results : [Clinic]
}

struct GeoLocation : Hashable, Codable {
    var geometry: Geometry
    struct Geometry: Hashable, Codable {
        var location : Location

        struct Location : Hashable, Codable {
            var lat : Double
            var lng : Double
        }
        
    }
}

struct GeoLocationResult: Hashable, Codable {
    var results : [GeoLocation]
}

// to get detailed information from place
struct DetailedClinic: Hashable, Codable {
    var current_opening_hours : Optional<OpeningHours>
    struct OpeningHours : Hashable, Codable {
        var weekday_text : [String] = []
    }
    var formatted_phone_number : Optional<String>
}

struct DetailedClinicWithResult: Hashable, Codable {
    var result: DetailedClinic
}

