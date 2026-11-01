enum Crumble {
    static func holds(_ tick: Int) -> Bool {
        let cycle = MotionPolicy.crumbleOn + MotionPolicy.crumbleOff
        return tick % cycle < MotionPolicy.crumbleOn
    }
}
