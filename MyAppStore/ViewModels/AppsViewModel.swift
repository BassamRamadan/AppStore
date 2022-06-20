//
//  AppsViewModel.swift
//  MyAppStore
//
//  Created by Bassam on 6/11/22.
//

import Foundation


class AppsViewModel{
    var AllCells = Blindable<[Feed]>()
    var appIndicator = Blindable<Bool>()
    var headerSocialApps = Blindable<[SocialApp]>()
    
    let urls: [Int:String] = [0: "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/10/apps.json", // top free apps
                              1: "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/10/apps.json", // top paid apps
                              2: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json", // music
                              3: "https://rss.applemarketingtools.com/api/v2/us/podcasts/top/10/podcasts.json" // prodcast
                             ]
    
    func getSectionDataCount(section: Int)->Int{
        if section == 0 && AllCells.value?.count ?? 0 == 0{
            return 0
        }
        if section > AllCells.value?.count ?? 0{
            return 0
        }
        return AllCells.value?[section].results.count ?? 0
    }
    
    func getHeaderSocialCount()-> Int{
        return headerSocialApps.value?.count ?? 0
    }
    func getCategorynName(section: Int)->String{
        if (section - 1) == 0 && AllCells.value?.count ?? 0 == 0{
            return ""
        }
        if (section - 1) > AllCells.value?.count ?? 0{
            return ""
        }
        return AllCells.value?[(section - 1)].title ?? ""
    }
    func setSocialCell(cell: HeaderSocialApp ,indexPath:IndexPath){
        guard let data = headerSocialApps.value?[indexPath.row] else {return}
        cell.banarImage.sd_setImage(with: URL(string: data.imageUrl))
        cell.btn.setTitle( data.name, for: .normal)
        cell.title.text = data.tagline
    }
    
    
    
    func setAppCell(cell: appCell ,indexPath:IndexPath){
        guard let data = AllCells.value?[indexPath.section-1].results[indexPath.row] else {return}
        cell.icon.sd_setImage(with: URL(string: data.artworkUrl100))
        cell.name.text = data.name
        cell.primaryName.text = data.artistName
    }
    
    func fetchTopFreeAppsGroup(){
        let dispatchGroup = DispatchGroup()
        var isLoaded: [Feed] = []
        appIndicator.value = true
        for i in 0...3{
            dispatchGroup.enter()
            AlamofireRequests.getMethod(url: self.urls[i] ?? "", headers: [:]) { (error, success, data) in
                if error != nil{
                    return
                }
                do {
                    let objects = try JSONDecoder().decode(AppGroup.self, from: data)
                    DispatchQueue.main.async{
                        isLoaded.append(objects.feed)
                    }
                    dispatchGroup.leave()
                } catch {
                    
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
                // whatever you want to do when all are done
            self.AllCells.value = isLoaded
            self.fetchHeaderData()
        }
    }
    
    func fetchHeaderData(){
        AlamofireRequests.getMethod(url: "https://api.letsbuildthatapp.com/appstore/social", headers: [:]) { (error, success, data) in
            if error != nil{
                return
            }
            do {
                let objects = try JSONDecoder().decode([SocialApp].self, from: data)
                self.headerSocialApps.value = objects
            } catch {
                
            }
        }
    }
}
