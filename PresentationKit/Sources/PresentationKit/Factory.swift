public enum Factory {
    public static func viewRenderer() -> ViewRenderer {
        return ConsoleViewRenderer()
    }
}