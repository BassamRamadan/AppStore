

import Foundation

class Blindable<T>{
    var value: T?{
        didSet{
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(compeletion: @escaping (T?)->()){
        self.observer = compeletion   // set implementation of observer closure
    }
}
