//
//  DataServices.swift
//  SocialPhoto
//
//  Created by Vinogradov Alexey on 30/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import Kingfisher

class ServiceManager {
    
    private init() { }
    static let shared = ServiceManager()
    private let session = URLSession.shared
    
    var isOnline = true
    
    // MARK: - AuthorizationService:
    //  Авторизует пользователя и выдает токен
            func signIn(parameters: [String:String], completionHandler: @escaping (Result<String>) -> Void) {
                
                guard let request = RequestManager.shared.getRequest(methodName: "signin", httpMethod: "POST", parametersBody: parameters) else {
                    return
                }
                    session.dataTask(with: request) { (data, response, error) in
                       
                        guard error == nil else {
                            completionHandler(.fail("Could not connect to the server."))
                            return
                        }
        
                        if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                            completionHandler(.fail(errorStatusResponce))
                        } else {
                            if let data = data,
                                let tokenJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String],
                                let token = tokenJson["token"] {
                                completionHandler(.success(token))
                            } else {
                                completionHandler(.fail("Transfer error"))
                            }
                        }
        
                    }.resume()
                }
            
        //  Деавторизует пользователя и инвалидирует токен
            func signOut(completionHandler: @escaping (Result<Bool>) -> Void) {
                
                guard let request = RequestManager.shared.getRequest(methodName: "signout", httpMethod: "POST", parametersBody: nil) else {
                    return
                }

                session.dataTask(with: request) { (data, response, error) in
                    guard error == nil else {
                        completionHandler(.fail("Could not connect to the server."))
                        return
                    }

                    guard let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) else {
                        completionHandler(.success(true))
                        return
                    }
                    completionHandler(.fail(errorStatusResponce))
      
                }.resume()
                
            }
            
        //  Проверяет валидность токена
            func checkToken(completionHandler: @escaping (Result<Bool>) -> Void) {
                guard let request = RequestManager.shared.getRequest(methodName: "checkToken", httpMethod: "GET", parametersBody: nil) else {
                    return
                }
       
                session.dataTask(with: request) { (data, response, error) in
                    guard error == nil else {
                        completionHandler(.fail("Could not connect to the server."))
                        return
                    }
                    
                    if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                        completionHandler(.fail(errorStatusResponce))
                    } else {
                        completionHandler(.success(true))
                    }
                    
                }.resume()
                
            }
    
    // MARK: - UserService:
    //  Возвращает информацию о текущем пользователе
        func getUser(completionHandler: @escaping (Result<User>) -> Void) {
            
            guard let request = RequestManager.shared.getRequest(methodName: "users/me", httpMethod: "GET", parametersBody: nil) else {
                return
            }
            
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let userData = try? JSONDecoder().decode(User.self, from: data)
                        guard let user = userData else { return }
                       
                        let saveToCoreData = DispatchWorkItem(block: {
                            let userToSave : UserStorage = CoreDataWorker.instance.getEntity(with: user.id)
                            let context = CoreDataWorker.instance.getContext()
                            userToSave.avatar = user.avatar
                            userToSave.currentUserFollowsThisUser = user.currentUserFollowsThisUser
                            userToSave.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
                            userToSave.followedByCount = Int64(user.followedByCount)
                            userToSave.followsCount = Int64(user.followsCount)
                            userToSave.fullName = user.fullName
                            userToSave.id = user.id
                            userToSave.username = user.username
                            CoreDataWorker.instance.save(context: context)
                        })
                        
                        DispatchQueue.main.async(execute: saveToCoreData)
                        saveToCoreData.notify(queue: DispatchQueue.main, execute: {
                            print("User saved to Core Data")
                            completionHandler(.success(user))
                        })

                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
            
            }.resume()
        }
        
    //  Возвращает информацию о пользователе с запрошенным id
        func getAnotherUser(id: String, completionHandler: @escaping (Result<User>) -> Void) {
            guard let request = RequestManager.shared.getRequest(methodName: "users/" + id, httpMethod: "GET", parametersBody: nil) else {
                return
            }

            session.dataTask(with: request) { (data, response, error) in

                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let userData = try? JSONDecoder().decode(User.self, from: data)
                        guard let user = userData else { return }
                        completionHandler(.success(user))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
                
                
                
            }.resume()
        }

    //  Подписывает текущего пользователя от пользователя с запрошенным ID
          func follow(id: String, completionHandler: @escaping (Result<User>) -> Void) {
            
            let parameter = ["userID" : id]
            
            guard let request = RequestManager.shared.getRequest(methodName: "users/follow", httpMethod: "POST", parametersBody: parameter) else {
                
                return
            }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let userData = try? JSONDecoder().decode(User.self, from: data)
                        guard let user = userData else { return }
                        completionHandler(.success(user))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
                
            }.resume()
        }
        
    //  Отписывает текущего пользователя от пользователя с запрошенным ID
        func unfollow(id: String, completionHandler: @escaping (Result<User>) -> Void) {
            
            let parameter = ["userID" : id]
            guard let request = RequestManager.shared.getRequest(methodName: "users/unfollow", httpMethod: "POST", parametersBody: parameter) else {
                return
            }
            
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let userData = try? JSONDecoder().decode(User.self, from: data)
                        guard let user = userData else { return }
                        completionHandler(.success(user))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
                
            }.resume()
        }
        
    //  Возвращает подписчиков пользователя с запрошенным ID
        func getFollowers(id: String, completionHandler: @escaping (Result<[User]>) -> Void) {
            guard let request = RequestManager.shared.getRequest(methodName: "users/" + id + "/followers", httpMethod: "GET", parametersBody: nil) else {
                       return
                   }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let userData = try? JSONDecoder().decode([User].self, from: data)
                        guard let user = userData else { return }
                        completionHandler(.success(user))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
                
            }.resume()
        }
        
    //  Возвращает подписки пользователя с запрошенным ID
        func getFollowing(id: String, completionHandler: @escaping (Result<[User]>) -> Void) {
            guard let request = RequestManager.shared.getRequest(methodName: "users/" + id + "/following", httpMethod: "GET", parametersBody: nil) else {
                return
            }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let userData = try? JSONDecoder().decode([User].self, from: data)
                        guard let user = userData else { return }
                        completionHandler(.success(user))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
                
            }.resume()
        }

    // MARK: - PostService:
    //  Возвращает публикации пользователя с запрошенным ID
        func getUserPosts(isCurrentUser: Bool, id: String, completionHandler: @escaping (Result<[Post]>) -> Void) {
           
            guard let request = RequestManager.shared.getRequest(methodName: "users/" + id + "/posts", httpMethod: "GET", parametersBody: nil) else {
                return
            }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let postsData = try? JSONDecoder().decode([Post].self, from: data)
                        guard let posts = postsData else { return }
                        
                        if isCurrentUser {
                            let saveToCoreData = DispatchWorkItem(block: {
                                for post in posts {
                                    let postToSave : PostStorage = CoreDataWorker.instance.getEntity(with: post.id)
                                    let context = CoreDataWorker.instance.getContext()
                                    postToSave.author = post.author
                                    postToSave.authorAvatar = post.authorAvatar
                                    postToSave.authorUsername = post.authorUsername
                                    postToSave.createdTime = post.createdTime
                                    postToSave.currentUserLikesThisPost =       post.currentUserLikesThisPost
                                    postToSave.descript = post.description
                                    postToSave.id = post.id
                                    postToSave.image = post.image
                                    postToSave.likeByCount = Int64(post.likedByCount)
                                    CoreDataWorker.instance.save(context: context)
                                }
                            })

                            DispatchQueue.main.async(execute: saveToCoreData)
                            saveToCoreData.notify(queue: DispatchQueue.main, execute: {
                                print("Posts saved to Core Data")
                                completionHandler(.success(posts))
                            })
                            
                        } else {
                            completionHandler(.success(posts))
                        }

                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
                
            }.resume()
        }
        
        //  Возвращает публикации пользователей на которых подписан текущий пользователь.

        func feed(completionHandler: @escaping (Result<[Post]>) -> Void) {
            
            guard let request = RequestManager.shared.getRequest(methodName: "posts/feed", httpMethod: "GET", parametersBody: nil) else {
                return
            }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let postsData = try? JSONDecoder().decode([Post].self, from: data)
                        guard let posts = postsData else { return }
                        
                        //Решает проблему с загрузкой фото
                        let urls = posts.map({ $0.image })
                        let prefetcher = ImagePrefetcher(urls: urls, options: [KingfisherOptionsInfoItem.forceRefresh], progressBlock: nil){ _,_,_ in }
                        prefetcher.start()
                        //
                        let saveToCoreData = DispatchWorkItem(block: {
                            for post in posts{
                                let postToSave : PostStorage = CoreDataWorker.instance.getEntity(with: post.id)
                                let context = CoreDataWorker.instance.getContext()
                                postToSave.author = post.author
                                postToSave.authorAvatar = post.authorAvatar
                                postToSave.authorUsername = post.authorUsername
                                postToSave.createdTime = post.createdTime
                                postToSave.currentUserLikesThisPost = post.currentUserLikesThisPost
                                postToSave.descript = post.description
                                postToSave.id = post.id
                                postToSave.image = post.image
                                postToSave.likeByCount = Int64(post.likedByCount)
                                CoreDataWorker.instance.save(context: context)
                            }
                        })
                        DispatchQueue.main.async(execute: saveToCoreData)
                        saveToCoreData.notify(queue: DispatchQueue.main, execute: {
                            print("Posts saved to Core Data")
                            completionHandler(.success(posts))
                        })
                        
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }

            }.resume()
        }
        
        //  Возвращает пользователей, поставивших лайк на публикацию с запрошенным ID.
        func usersLikeThisPost(id: String, completionHandler: @escaping (Result<[User]>) -> Void) {
            
            guard let request = RequestManager.shared.getRequest(methodName: "posts/" + id + "/likes", httpMethod: "GET", parametersBody: nil) else {
                return
            }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let userData = try? JSONDecoder().decode([User].self, from: data)
                        guard let user = userData else { return }
                        completionHandler(.success(user))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
                
            }.resume()
        }
        
        //  Ставит лайк от текущего пользователя на публикации с запрошенным ID.
        func likePost(postID: String, completionHandler: @escaping (Result<Post>) -> Void) {
            
            let parameter = ["postID" : postID]
            guard let request = RequestManager.shared.getRequest(methodName: "posts/like", httpMethod: "POST", parametersBody: parameter) else {
                return
            }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let postData = try? JSONDecoder().decode(Post.self, from: data)
                        guard let post = postData else { return }
                        completionHandler(.success(post))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }
                
            }.resume()
        }
        
        //  Удаляет лайк от текущего пользователя на публикации с запрошенным ID.
        func unlikePost(postID: String, completionHandler: @escaping (Result<Post>) -> Void) {
           
            let parameter = ["postID" : postID]
            guard let request = RequestManager.shared.getRequest(methodName: "posts/unlike", httpMethod: "POST", parametersBody: parameter) else {
                return
            }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let postData = try? JSONDecoder().decode(Post.self, from: data)
                        guard let post = postData else { return }
                        completionHandler(.success(post))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }

            }.resume()
        }
        
        //  Создает новую публикацию.
        func postNewPost(parameters: [String:String], completionHandler: @escaping (Result<Post>) -> Void) {
            
            guard let request = RequestManager.shared.getRequest(methodName: "posts/create", httpMethod: "POST", parametersBody: parameters) else {
                return
            }

            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completionHandler(.fail("Could not connect to the server."))
                    return
                }
                
                if let errorStatusResponce = RequestManager.shared.getErrorResponce(response: response) {
                    completionHandler(.fail(errorStatusResponce))
                } else {
                    if let data = data {
                        let postData = try? JSONDecoder().decode(Post.self, from: data)
                        guard let post = postData else { return }
                        completionHandler(.success(post))
                    } else {
                        completionHandler(.fail("Transfer error"))
                    }
                }

            }.resume()
        }
    
}

