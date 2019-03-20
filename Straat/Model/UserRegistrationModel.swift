//
//  UserRegistrationModel.swift
//  Straat
//
//  Created by John Higgins M. Avila on 12/02/2019.
//

import Foundation
class UserRegistrationModel {
    var gender: String?
    var firstname: String?
    var lastname: String?
    var username: String?
    var userPrefix: String? //new
    var postalCode: String?
    var postalNumber: String?
    var street: String?
    var town: String?
    var email: String?
    var phoneNumber: String?
    var password: String?
    var tac: Bool?
    var isVolunteer: Bool?
    var hostId: String?
    var long: Double?
    var lat: Double?
    var team: TeamModel?

    
    // user registration
    init(
        gender: String?,
        firstname: String?,
        lastname: String?,
        username: String?,
        userPrefix: String?,
        postalCode: String?,
        postalNumber: String?,
        street: String?,
        town: String?,
        email: String?,
        phoneNumber: String?,
        password: String?,
        tac: Bool?,
        isVolunteer: Bool?,
        hostId: String?,
        long: Double?,
        lat: Double?,
        team: TeamModel?
    ) {
        self.gender = gender
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.userPrefix = userPrefix
        self.postalCode = postalCode
        self.postalNumber = postalNumber
        self.street = street
        self.town = town
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.tac = tac
        self.isVolunteer = isVolunteer
        self.hostId = hostId
        self.long = long
        self.lat = lat
        self.team = team
    }
    
    init(
        gender: String?,
        firstname: String?,
        lastname: String?,
        username: String?,
        postalCode: String?,
        postalNumber: String?,
        street: String?,
        town: String?,
        email: String?,
        phoneNumber: String?,
        password: String?,
        tac: Bool?,
        isVolunteer: Bool?,
        hostId: String?,
        long: Double?,
        lat: Double?,
        team: TeamModel?
        ) {
        self.gender = gender
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.postalCode = postalCode
        self.postalNumber = postalNumber
        self.street = street
        self.town = town
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.tac = tac
        self.isVolunteer = isVolunteer
        self.hostId = hostId
        self.long = long
        self.lat = lat
        self.team = team
    }
}
