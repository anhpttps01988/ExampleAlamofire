import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var lbUserInfo: UILabel!
    
    func setUser(_ user: User) {
        lbUserInfo.text = "\(user.id) - \(user.title)"
    }

}
