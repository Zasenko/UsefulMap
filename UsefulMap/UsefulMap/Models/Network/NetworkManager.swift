//
//  NetworkManager.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import Foundation

enum NetworkManagerErrors: Error {
    case decoderError
    case bedUrl
    case invalidStatusCode
}

class NetworkManager {
    
    //MARK: - Private properties
    
    private let scheme = "https"
    private let host = "zasenko.000webhostapp.com"
}

extension NetworkManager {
    
    //MARK: - Functions
    
    func login(login: String, password: String) async throws -> LoginResult {
        var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = "/login.php"
            components.queryItems = [
                URLQueryItem(name: "user_login", value: login),
                URLQueryItem(name: "user_password", value: password)
            ]
            return components
        }
        guard let url = urlComponents.url else {
            throw NetworkManagerErrors.bedUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerErrors.invalidStatusCode
        }
        guard let decodedLoginResult = try? JSONDecoder().decode(LoginResult.self, from: data) else {
            throw NetworkManagerErrors.decoderError
        }
        return decodedLoginResult
    }
    
    func registration(login: String, password: String) async throws -> RegistrationResult {
        var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = "/registration.php"
            components.queryItems = [
                URLQueryItem(name: "user_login", value: login),
                URLQueryItem(name: "user_password", value: password),
                URLQueryItem(name: "user_name", value: String(login.split(separator: "@").first ?? ""))
            ]
            return components
        }
        guard let url = urlComponents.url else {
            throw NetworkManagerErrors.bedUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerErrors.invalidStatusCode
        }
        guard let decodedRegistrationResult = try? JSONDecoder().decode(RegistrationResult.self, from: data) else {
            throw NetworkManagerErrors.decoderError
        }
        return decodedRegistrationResult
    }
    
    func getAllCountries() async throws -> Countries {
        var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = "/get_all_countries.php"
            return components
        }
        guard let url = urlComponents.url else {
            throw NetworkManagerErrors.bedUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerErrors.invalidStatusCode
        }
        guard let decodedCountries = try? JSONDecoder().decode(Countries.self, from: data) else {
            throw NetworkManagerErrors.decoderError
        }
        return decodedCountries
    }
    
    func getAllCitiesByCountryId(countryId: Int) async throws -> Cities {
        var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = "/get_all_cities_by_country_id.php"
            components.queryItems = [
                URLQueryItem(name: "country_id", value: String(countryId))
            ]
            return components
        }
        guard let url = urlComponents.url else {
            throw NetworkManagerErrors.bedUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerErrors.invalidStatusCode
        }
        guard let decodedCities = try? JSONDecoder().decode(Cities.self, from: data) else {
            throw NetworkManagerErrors.decoderError
        }
        return decodedCities
    }
    
    func getAllPlacesByCityId(cityId: Int) async throws -> Places {
        var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = "/get_all_places_by_city_id.php"
            components.queryItems = [
                URLQueryItem(name: "city_id", value: String(cityId))
            ]
            return components
        }
        guard let url = urlComponents.url else {
            throw NetworkManagerErrors.bedUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerErrors.invalidStatusCode
        }
        guard let decodedPlaces = try? JSONDecoder().decode(Places.self, from: data) else {
            throw NetworkManagerErrors.decoderError
        }
        return decodedPlaces
    }
    
    func getPlaceInfoById(placeId: Int) async throws -> Place {
        var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = "/get_place_info_by_id.php"
            components.queryItems = [
                URLQueryItem(name: "place_id", value: String(placeId))
            ]
            return components
        }
        guard let url = urlComponents.url else {
            throw NetworkManagerErrors.bedUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerErrors.invalidStatusCode
        }
        guard let decodedPlace = try? JSONDecoder().decode(Place.self, from: data) else {
            throw NetworkManagerErrors.decoderError
        }
        return decodedPlace
    }
    
    func getAllPlacesByUserLocation(latitude: Double, longitude: Double, radius: Int = 10) async throws -> Places {
        var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = "/get_places_by_location.php"
            components.queryItems = [
                URLQueryItem(name: "user_latitude", value: String(latitude)),
                URLQueryItem(name: "user_longitude", value: String(longitude)),
                URLQueryItem(name: "radius", value: String(radius))
            ]
            return components
        }
        guard let url = urlComponents.url else {
            throw NetworkManagerErrors.bedUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkManagerErrors.invalidStatusCode
        }
        guard let decodedPlaces = try? JSONDecoder().decode(Places.self, from: data) else {
            throw NetworkManagerErrors.decoderError
        }
        return decodedPlaces
    }
}
