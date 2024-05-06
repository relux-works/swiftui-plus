public extension Animation {
    static var gentleEaseOut: Animation {
        .interpolatingSpring(
            mass: 5,
            stiffness: 60,
            damping: 73,
            initialVelocity: 1.2
        )
    }
}
