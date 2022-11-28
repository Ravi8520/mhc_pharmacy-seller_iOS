//
//  NetworkHelper.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit

struct NetworkHelper {
    
    static func getJsonString<T: Encodable>(data: T) -> String? {
        
        do {
            
            let jsonData = try JSONEncoder().encode(data)
            return String(data: jsonData, encoding: .utf8)
            
        } catch {
            
            Log.e("Json encoding error:- \(error)")
            return nil
        }
    }
    
    static func decodeJsonData<T: Decodable>(data: Data, decodeWith: T.Type) -> T? {
        
        do {
            
            let type = try JSONDecoder().decode(decodeWith.self, from: data)
            return type
            
        } catch {
            
            Log.e("Json decoding error:- \(error)")
            return nil
        }
    }
    
    static func encodeJson<T: Encodable>(encodeWith: T, data: Data) -> Data? {
        
        do {
            
            let type = try JSONEncoder().encode(encodeWith)
            return type
            
        } catch {
            
            Log.e("Json encoding error:- \(error)")
            return nil
        }
        
    }
    
    static func getJSONString(object: Any?) -> String? {
        
        guard object != nil else { return nil }
        
        guard let data = try? JSONSerialization.data(withJSONObject: object!, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func getJsonData(object: Any?) -> Data? {
        
        guard object != nil else { return nil }
        
        guard let data = try? JSONSerialization.data(withJSONObject: object!, options: []) else {
            return nil
        }
        
        return data
    }
    
}

enum StatusCode : Int {
    case success = 200
    case unauthorised = 401
    case notFound = 404
    case internalServerError = 500
}

public enum CustomError: LocalizedError {
    
    case invalidUrl
    case serverError
    case statusCodeError
    case unauthenticated
    case invalidParameter
    case missinJsonData
    case invalidJsonData
    
    public var errorDescription: String? {
        
        switch self {
            case .invalidUrl:
                return HTTPErrorString.invalidUrl
            case .serverError:
                return HTTPErrorString.serverError
            case .statusCodeError:
                return HTTPErrorString.statusCodeError
            case .unauthenticated:
                return HTTPErrorString.unauthenticated
            case .invalidParameter:
                return HTTPErrorString.invalidParameter
            case .missinJsonData:
                return HTTPErrorString.missinJsonData
            case .invalidJsonData:
                return HTTPErrorString.invalidJsonData
        }
    }
    
    private struct HTTPErrorString {
        static let invalidUrl = "Please enter valid url."
        static let serverError = "Something went wrong, Please try again later."
        static let statusCodeError = "Invalid status code."
        static let unauthenticated = "User Unauthenticated."
        static let invalidParameter = "Please enter valid parameter."
        static let missinJsonData = "Json data is missing."
        static let invalidJsonData = "Json data is invalid."
    }
}

struct HTTPHeaderConstant {
    static let authorization = "apikey"//"Authorization"
    static let contentType = "Content-Type"
    static let jsonContentType = "application/json"
    static let accept = "Accept"
    static func multipartType(boundary: String) -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
}

enum MimeTypes: String {
    
    case jpeg = "image/jpeg"
    case jpg = "image/jpg"
    case png = "image/png"
    case pdf = "application/pdf"
    case wav = "audio/wav"
    
    var fileExtension: FileExtensions.RawValue {
        get {
            switch self {
                case .jpeg:
                    return FileExtensions.jpeg.rawValue
                case .jpg:
                    return FileExtensions.jpg.rawValue
                case .png:
                    return FileExtensions.png.rawValue
                case .pdf:
                    return FileExtensions.pdf.rawValue
                case .wav:
                    return FileExtensions.wav.rawValue
            }
        }
    }
    
    enum FileExtensions: String {
        case jpeg = "jpeg"
        case jpg = "jpg"
        case png = "png"
        case pdf = "pdf"
        case wav = "wav"
    }
}

struct FileData {
    var data: Data
    var mimeType: MimeTypes
    var key: String
}

