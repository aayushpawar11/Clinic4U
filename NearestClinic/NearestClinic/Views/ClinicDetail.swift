//
//  ClinicDetail.swift
//  NearestClinic
//
//  Created by Aayush Pawar on 10/27/22.
//

import SwiftUI

struct ClinicDetail: View {
    var clinic: Clinic
    var detailedClinic : DetailedClinic
    @State var isActive : Bool = false

    init (clinic : Clinic, isActive: Bool) {
        self.detailedClinic = getDetailedInfoOfClinic(clinic.place_id)
        self.clinic = clinic
        self.isActive = isActive
    }

    var body: some View {
        ScrollView {
            MapView(location: PlaceToLocate(inputLoc: clinic.locationCoordinate))
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            VStack(alignment: .leading) {
                Text(clinic.name)
                    .font(.title)

                HStack {
                    StarsView(rating:CGFloat(clinic.rating))
                    Text("(" + String(clinic.user_ratings_total) + ")")
                    Spacer()
                    Text(clinic.vicinity).onTapGesture {
                        openAppleMaps(coordinate:clinic.locationCoordinate)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                Text("About \(clinic.name)")
                    .font(.title2)
                Spacer()
                if (!detailedClinic.formatted_phone_number!.isEmpty) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 16.0, height: 16.0)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.green)
                        Text(detailedClinic.formatted_phone_number!)
                        
                    }.onTapGesture {
                        callNumber(phoneNumber:detailedClinic.formatted_phone_number!)
                    }
                }
                if (detailedClinic.current_opening_hours != nil) {
                    ForEach(detailedClinic.current_opening_hours!.weekday_text, id:\.self) { opening_hours in
                        Text(opening_hours)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(clinic.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isActive = true
        }
    }
}

