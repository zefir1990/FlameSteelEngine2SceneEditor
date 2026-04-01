struct ModifiedView: View {
    let _content: View
    let size: Size
}

extension View {
    func preferredSize(_ size: Size) -> View {
        return ModifiedView(_content: self, size: size)
    }
}
