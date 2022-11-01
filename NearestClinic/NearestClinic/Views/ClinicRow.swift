//
//  ClinicRow.swift
//  NearestClinic
//
//  Created by Aayush Pawar on 10/27/22.
//

import SwiftUI

struct ClinicRow: View {
    var clinic: Clinic

    var body: some View {
        VStack(alignment: .leading) {

            Text(clinic.name)

            HStack {
                StarsView(rating:CGFloat(clinic.rating))
                Text("(" + String(clinic.user_ratings_total) + ")")
                Spacer()
                Text(clinic.vicinity)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)


        }
    }
}

