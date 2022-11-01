//
//  MapView.swift
//  NearestClinic
//
//  Created by Aayush Pawar on 10/27/22.
//

import SwiftUI
import MapKit

struct PlaceToLocate : Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.coordinate = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
    init(id: UUID = UUID(), inputLoc : CLLocationCoordinate2D) {
        self.id = id
        self.coordinate = inputLoc
    }
}

struct MapView: View {
    var location: PlaceToLocate
    @State var region: MKCoordinateRegion = MKCoordinateRegion()

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [location]) { item in
            MapAnnotation(coordinate: location.coordinate) {
                VStack(spacing: 0) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                        .offset(x: 0, y: -5)
                }.onTapGesture() {
                    openAppleMaps(coordinate: location.coordinate)
                }
            }
        }
        .onAppear {
            setRegion(location.coordinate)
        }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

