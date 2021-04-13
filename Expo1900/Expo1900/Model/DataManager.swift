//
//  ExhibitionDataParser.swift
//  Expo1900
//
//  Created by Seungjin Baek on 2021/04/12.
//

import Foundation

struct DataManager {
    
    func parseJSONDataToExhibitionData<T: Decodable>(with jsonData: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedData = try jsonDecoder.decode(T.self, from: jsonData)
            return decodedData
        } catch {
            throw ParsingError.JSONParsingError
        }
    }
    
}
