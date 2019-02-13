//
//  PostalModel.swift
//  
//
//  Created by John Higgins M. Avila on 12/02/2019.
//


import Foundation

class PostalModel {
    var postcode: String?
    var municipality: String?
    var city: String?
    var street: String?
    
    init (postcode: String?, municipality: String?, city: String?, street: String?) {
        self.postcode = postcode
        self.municipality = municipality
        self.city = city
        self.street = street
    }
}

/* Postal data structure
 {
 "addresses": [
 {
 "purpose": null,
 "postcode": "2521AA",
 "surface": null,
 "municipality": {
 "id": "0518",
 "label": "'s-Gravenhage"
 },
 "city": {
 "id": "1245",
 "label": "'s-Gravenhage"
 },
 "letter": null,
 "geo": {
 "center": {
 "rd": {
 "type": "Point",
 "coordinates": [
 81485.213,
 453098.022
 ],
 "crs": {
 "type": "name",
 "properties": {
 "name": "urn:ogc:def:crs:EPSG::28992"
 }
 }
 },
 "wgs84": {
 "type": "Point",
 "coordinates": [
 4.3151897,
 52.0612965
 ],
 "crs": {
 "type": "name",
 "properties": {
 "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
 }
 }
 }
 }
 },
 "nen5825": {
 "postcode": "2521 AA",
 "street": "CALANDKADE"
 },
 "addition": null,
 "number": 1,
 "year": null,
 "province": {
 "id": "28",
 "label": "Zuid-Holland"
 },
 "id": "0518200001635833",
 "type": "Ligplaats",
 "street": "Calandkade",
 "_links": {
 "self": {
 "href": "https://api.postcodeapi.nu/v2/addresses/0518200001635833/"
 }
 }
 }
 ]
 }
 */
