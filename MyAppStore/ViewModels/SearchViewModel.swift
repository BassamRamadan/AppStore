//
//  SearchViewModel.swift
//  MyAppStore
//
//  Created by Bassam on 6/8/22.
//

import Foundation

class SearchViewModel {
    var appResult = Blindable<[Result]>()
    var appIndicator = Blindable<Bool>()
    var isSearching = Blindable<Bool>()
    var searchText: String = "instagram"{
        didSet{
            self.isSearching.value = true
            self.fetchSearchApi()
        }
    }
    
    func fetchCellData(cell: SearchResultCell,row: Int){
        if let rowData = appResult.value?[row]{
            cell.ResultCell = rowData
        }
    }
    
    func fetchSearchApi(){
        self.appIndicator.value = true
        AlamofireRequests.getMethod(url: "https://itunes.apple.com/search?term=\(searchText)&entity=software", headers: [:]) { (Error, Bool, Data) in
            if Error != nil {
                
                return
            }
            do {
                let objects = try JSONDecoder().decode(SearchResult.self, from: Data)
                self.appResult.value = objects.results
                self.appIndicator.value = false
                self.isSearching.value = false
            } catch {
                
            }
        }
    }
    
}
