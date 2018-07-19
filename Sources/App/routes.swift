import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.post("send"){ req -> Future<Response> in
        //let msg = Message(id: UUID(), username: "johnlin", content: "Hello from John", date: Date())
        let username: String = try req.content.syncGet(at: "username")
        let content:String = try req.content.syncGet(at: "content")
        
        let msg = Message(id: nil, username: username, content: content, date: Date())
        // Fluent will fill the id for us automatically
        
        return msg.save(on: req).map(to: Response.self){ _ in
            return req.redirect(to: "/")
            
        //            Tip: Both map() and flatMap() are designed to attach work to be run when a future completes. You can’t use the wrong one by mistake – Xcode will refuse to compile. The simple rule is this: if the work you’re attaching returns a future, you should use flatMap(), otherwise use map().
        //

        }
    }
    
    router.get("list"){ req -> Future<[Message]> in
        return Message.query(on: req).sort(\Message.date, .descending).all()
        
    }
    
    router.get{ req -> Future<View>  in
        return Message.query(on: req).all().flatMap(to: View.self){
            messages in
            let context = ["messages": messages]
            return try req.view().render("home", context)

        }
    }
}
