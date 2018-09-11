//
//  EldordynSingletony.swift
//  Memories
//
//  Created by Eldor Makkambayev on 25.07.2018.
//  Copyright © 2018 Eldor Makkambayev. All rights reserved.
//

import Foundation

class NotesModel{
  var id: String?
  var title: String?
  var note: String?
  
  init(id: String?, title: String?, note: String?) {
    self.id = id
    self.title = title
    self.note = note
  }
}

class UsernameModel{
  var name: String?
  
  init(name: String?) {
    self.name = name
  }
}

class MemoriesModel{
  var id: String?
  var memory: String?
  var imageURL: [String?]
  var videoURL: [String?]
  var date: String?
  
  init(id: String?, memory: String?, date: String?, imageURL: [String?], videoURL: [String?]) {
    self.id = id
    self.memory = memory
    self.date = date
    self.imageURL = imageURL
    self.videoURL = videoURL

  }
}
