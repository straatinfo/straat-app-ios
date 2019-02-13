//
//  HostModel.swift
//  Straat
//
//  Created by Global Array on 07/02/2019.
//

import Foundation

class HostModel {
    var id : String?
    var lat : Double?
    var long : Double?
    var email : String?
    var streetName : String?
    var city: String?
    var country : String?
    var postalCode : String?
    
    
    init( hostID : String?, hostLat : Double?, hostLong : Double?, hostEmail : String?, hostStreet : String?, hostCity : String?, hostCountry : String?, hostPostalCode: String?) {
        
        id = hostID
        lat = hostLat
        long = hostLong
        email = hostEmail
        streetName = hostStreet
        city = hostCity
        country = hostCountry
        postalCode = hostPostalCode
        
        self.id = hostID
        self.lat = hostLat
        self.long = hostLong
        self.email = hostEmail
        self.username = username
        self.streetName = streetName
        self.city = city
        self.country = country
        self.postalCode = postalCode
        self.phoneNumber = phoneNumber
        self.isVolunteer = isVolunteer
        self.language = language
    }
}

/* HOST DATA Structure
 "data": {
    "_id": "5a7b485a039e2860cf9dd19a",
    "updatedAt": "2019-02-03T08:32:58.063Z",
    "createdAt": "2018-06-07T00:51:24.102Z",
    "hostName": "'s-Gravenhage",
    "email": "denhaag@straat.info",
    "username": "denhaag",
    "streetName": "Postbus 12600",
    "city": "'s-Gravenhage",
    "country": "Netherlands",
    "postalCode": "2500 DJ",
    "phoneNumber": "14070",
    "_role": {
        "_id": "5a75c9de3a06a627a7e8af45",
        "updatedAt": "2018-06-07T00:51:20.508Z",
        "createdAt": "2018-06-07T00:51:20.508Z",
        "name": "Host",
        "code": "HOST",
        "__v": 0,
        "users": [],
        "accessLevel": 2
    },
    "password": "STRING",
    "houseNumber": null,
    "state": null,
    "long": 4.315667,
    "lat": 52.077646,
    "fname": null,
    "lname": null,
    "hostPersonalEmail": null,
    "_activeDesign": {
        "_id": "5b24faa449c8a10014cc6ed9",
        "updatedAt": "2018-06-16T11:55:41.630Z",
        "createdAt": "2018-06-16T11:55:16.997Z",
        "_host": "5a7b485a039e2860cf9dd19a",
        "colorOne": "#f18080",
        "colorTwo": "#ebea80",
        "colorThree": "#9adedf",
        "_profilePic": "5b24fabd49c8a10014cc6eda",
        "designName": "test design 2018 06 16"
    },
    "softRemoved": false,
    "isSpecific": true,
    "isActivated": true,
    "isBlocked": null,
    "isOnline": false,
    "isVolunteer": false,
    "socketToken": null,
    "fcmToken": null,
    "language": "nl",
    "setting": {
        "radius": 300,
        "sound": true,
        "vibrate": true,
        "isNotification": true
    },
    "geoLocation": {
        "coordinates": [
            0,
            0
        ],
        "type": "Point"
    }
 }
 */
