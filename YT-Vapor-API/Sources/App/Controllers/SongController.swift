//
//  SongController.swift
//
//
//  Created by Pedro Franco on 13/10/23.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":songID") { song in
            song.delete(use: delete)
        }
    }
    
    // GET
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    // POST - /songs
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        
        return song.save(on: req.db).transform(to: .ok)
    }
    
    // PUT - /songs
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)

        // .find = returns an optional
        return Song.find(song.id, on: req.db)
            // nil? ;-;
            .unwrap(or: Abort(.notFound))
            // not nil '-'
            .flatMap {
                $0.title = song.title
                // return 200 - ok
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    // DELETE - /songs/id
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        // find by id
        Song.find(req.parameters.get("songID"), on: req.db)
            // nil? ;-;
            .unwrap(or: Abort(.notFound))
            // not nil '-'
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
