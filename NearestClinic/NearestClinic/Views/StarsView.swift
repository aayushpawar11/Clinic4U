//
//  StarView.swift
//  NearestClinic
//
//  Created by Aayush Pawar on 10/29/22.
//

import SwiftUI

struct StarsView: View {
    var rating: CGFloat
    var maxRating: Int = 5

    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 16.0, height: 16.0)
                    .aspectRatio(contentMode: .fit)
            }
        }

        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .frame(width: 16.0, height: 16.0)
                        .foregroundColor(.yellow)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
    }
}
