//
//  CoronavirusAPI.swift
//  Coronavirus
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import Foundation

class CoronavirusAPI {
    static let owner = "Coronavirus COVID-19 Global Cases by TruHee"
    static let website = "https://gisanddata.maps.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6"
    static let endpoint = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Confirmed%20desc%2CCountry_Region%20asc%2CProvince_State%20asc&outSR=102100&resultOffset=0&resultRecordCount=250&cacheHint=true"
    
    static var lastUpdateDate: String?
    static func getCountries() -> [Country] {
        if let url = URL(string: endpoint) {
            if let data = try? Data(contentsOf: url) {
                guard let jsonFeatures = try? JSONDecoder().decode(FeaturesJSON.self, from: data) else { return [] }
                
                var featureDictionary = [String: CountryJSON]()
                
                for feature in jsonFeatures.features {
                    let key = feature.attributes.Country_Region
                    if featureDictionary[key] != nil {
                        featureDictionary[key]!.Confirmed += feature.attributes.Confirmed
                        featureDictionary[key]!.Recovered += feature.attributes.Recovered
                        featureDictionary[key]!.Deaths += feature.attributes.Deaths
                        if featureDictionary[key]!.Last_Update < feature.attributes.Last_Update {
                            featureDictionary[key]!.Last_Update = feature.attributes.Last_Update
                        }
                    } else {
                        featureDictionary[key] = feature.attributes
                    }
                }
                
                setLastUpdateDate(features: jsonFeatures.features)
                
                var countries = [Country]()
                
                for country in featureDictionary.values {
                    countries.append(Country(country: country.Country_Region, longitude: country.Long_, latitude: country.Lat, confirmed: country.Confirmed, recovered: country.Recovered, deaths: country.Deaths, lastUpdate: getReadableDate(milliseconds: country.Last_Update / 1000.0)))
                }
                
                return countries.sorted(by: { $0.confirmed > $1.confirmed })
            }
        }
        return []
    }
    
    private static func setLastUpdateDate(features: [FeatureJSON]) {
        var lastUpdate = 0.0
        
        for feature in features {
            let date = feature.attributes.Last_Update
            if date > lastUpdate {
                lastUpdate = date
            }
        }
        
        lastUpdateDate = getReadableDate(milliseconds: lastUpdate / 1000.0)
    }
    
    private static func getReadableDate(milliseconds timeStamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    private static func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }

}
