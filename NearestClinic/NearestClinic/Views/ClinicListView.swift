//
//  ClinicListView.swift
//  NearestClinic
//
//  Created by Aayush Pawar on 10/27/22.
//

import SwiftUI

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(.gray)
            .padding(10)
    }
}

struct ClinicListView: View {
    @State var zipCode: String = ""
    @State private var navTitle : String = "Clinic 4U"

    var body: some View {
        NavigationView {
            if zipCode.isEmpty || zipCode.count != 5 {
                VStack {
                    Image(uiImage: UIImage(named: "clinic4u-logo.png")!)
                        .resizable()
                        .frame(width: 128.0, height: 128.0)
                        .aspectRatio(contentMode: .fit)
                    Text("Clinic4U").font(.title)
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Enter zip code to search", text:$zipCode)
                            .keyboardType(.numberPad)
                            .frame(width:200)
                    }.underlineTextField()
                }
            } else {
                List(clinics, id: \.self) { clinic in
                    NavigationLink {
                        ClinicDetail(clinic: clinic, isActive:true)
                    } label: {
                        ClinicRow(clinic: clinic)
                    }
                }
                .navigationBarTitle(navTitle, displayMode: .large)
                .searchable(text: $zipCode,
                            placement:.navigationBarDrawer(displayMode: .always),
                            prompt: "Enter zip code to search")
            }
        }
    }

    var clinics : [Clinic]  {
        if zipCode.isEmpty || zipCode.count != 5 {
            return []
        } else {
            var clinics : [Clinic] = loadFromURL(zipCode)
            clinics = filterClinics(clinics)
            return clinics
        }
    }
}
