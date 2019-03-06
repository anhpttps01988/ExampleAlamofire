
struct User: Codable {
    let userId: Int? = -1
    let id: Int
    let title: String
    let body: String? = nil
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
