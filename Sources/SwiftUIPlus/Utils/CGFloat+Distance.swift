
extension CGPoint {
    var distance: CGFloat {
        sqrt(pow(self.x, 2) + pow(self.y, 2))
    }
}

extension CGSize {
    var distance: CGFloat {
        sqrt(pow(self.width, 2) + pow(self.height, 2))
    }
}
