//
//  ObservableObjectMapper.swift
//  yupao
//
//  Created by payne on 2019/1/18.
//  Copyright © 2019 payne. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

// MARK: - 扩展RxSwift的Observable，通过ObjectMapper,实现转模型(对象，数组)
extension Observable {
    
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            guard let dic = response as? [String: Any] else {
                throw RxSwiftMoyaError.JSONError
            }
            return Mapper<T>().map(JSON: dic)!
        }
    }
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            guard let array = response as? [Any] else {
                throw RxSwiftMoyaError.JSONError
            }
            
            guard let dicts = array as? [[String: Any]] else {
                throw RxSwiftMoyaError.JSONError
            }
            
            return Mapper<T>().mapArray(JSONArray: dicts)
        }
    }
    
}

enum RxSwiftMoyaError: String {
    case JSONError
    case OtherError
}

extension RxSwiftMoyaError: Swift.Error {}
