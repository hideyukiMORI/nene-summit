import Testing

@testable import NeNeSummitCore

@Test func twoHeldKeysShareOneInput() {
    var chord = PlayChord()
    let held = HeldPlay().with(HeldPlay.right).with(HeldPlay.jump)
    let input = chord.make(held)
    #expect(input.horizontal == .right)
    #expect(input.jump == .pressed)
    #expect(input.dash == .off)
}

@Test func leftAndRightCancel() {
    var chord = PlayChord()
    let input = chord.make(HeldPlay().with(HeldPlay.left).with(HeldPlay.right))
    #expect(input.horizontal == .none)
}

@Test func holdingJumpDoesNotPressAgain() {
    var chord = PlayChord()
    let held = HeldPlay().with(HeldPlay.jump)
    #expect(chord.make(held).jump == .pressed)
    #expect(chord.make(held).jump == .held)
    #expect(chord.make(HeldPlay()).jump == .released)
    #expect(chord.make(HeldPlay()).jump == .off)
}

@Test func holdingDashFiresOnce() {
    var chord = PlayChord()
    let held = HeldPlay().with(HeldPlay.dash)
    #expect(chord.make(held).dash == .pressed)
    #expect(chord.make(held).dash == .off)
}

@Test func holdingUpStartsOneJump() {
    var chord = PlayChord()
    let held = HeldPlay().with(HeldPlay.up)
    let first = chord.make(held)
    #expect(first.vertical == .up)
    #expect(first.jump == .pressed)
    #expect(chord.make(held).jump == .held)
}
