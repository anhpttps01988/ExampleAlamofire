import Alamofire

class AlamofireRepo {
    
    static var INSTANCE: AlamofireRepo? = nil
    
    public static func newInstance() -> AlamofireRepo {
        if (INSTANCE == nil) {
            INSTANCE = AlamofireRepo()
        }
        return INSTANCE!
    }
    
    func makeRequestGetUserList(onSuccess: @escaping ([User]?) -> Void, onError: @escaping (String?) -> Void) {
        let postfix = "/posts"
        AF.request(ServiceAPI.BASE_URL + postfix)
            .responseJSON { response in
                guard response.result.error == nil else {
                    onError("Error calling GET \(postfix)")
                    return
                }
                guard let json = response.result.value as? [[String: Any]] else {
                    if let error = response.result.error {
                        onError("Error \(error)")
                    } else {
                        onError("\(response.result.value ?? "Something went wrong")")
                    }
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let userList = try decoder.decode([User].self, from: jsonData)
                    onSuccess(userList)
                } catch {
                    onError("Parse json error")
                }
        }
    }
    
    func makeRequestAddUser(user: User, onSucces: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let postfix = "/post"
        AF.request(ServiceAPI.BASE_URL + postfix, method: .post, parameters: user.asDictionary(), encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.error != nil {
                onError("\(response.result.error ?? "Something went wrong!" as! Error)")
                return
            }
            onSucces()
        }
    }
    
    func makeRequestUpdateUser(user: User, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let postfix = "/post/\(user.id)"
        AF.request(ServiceAPI.BASE_URL + postfix, method: .put, parameters: user.asDictionary(), encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.error != nil {
                onError("\(response.result.error ?? "Something went wrong!" as! Error)")
                return
            }
            onSuccess()
        }
    }
    
    func makeRequestDeleteUser(user: User, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let postfix = "/post/\(user.id)"
        AF.request(ServiceAPI.BASE_URL + postfix, method: .delete, parameters: user.asDictionary(), encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.error != nil {
                onError("\(response.result.error ?? "Something went wrong!" as! Error)")
                return
            }
            onSuccess()
        }
    }
}

extension Encodable {
    func asDictionary() -> [String: Any] {
        let data = try! JSONEncoder().encode(self)
        guard let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}
