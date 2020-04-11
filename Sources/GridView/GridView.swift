
import Foundation
import SwiftUI
import VariadicViewBuilder

public struct GridView: View {
    let columns: Int
    let columnAlignment: VerticalAlignment
    let columnSpacing: CGFloat?

    let rowAlignment: HorizontalAlignment
    let rowSpacing: CGFloat?

    let content: [AnyView]

    public init(columns: Int,
                columnAlignment: VerticalAlignment = .center,
                columnSpacing: CGFloat? = nil,
                rowAlignment: HorizontalAlignment = .center,
                rowSpacing: CGFloat? = nil,
                @VariadicViewBuilder content: () -> [AnyView]) {

        self.columns = columns
        self.columnAlignment = columnAlignment
        self.columnSpacing = columnSpacing
        self.rowAlignment = rowAlignment
        self.rowSpacing = rowSpacing
        self.content = content()
    }

    public var body: some View {
        let rows = content.chunked(into: columns)
        return GeometryReader { geometry -> AnyView in
            let expectedWidth = (geometry.size.width - (self.columnSpacing ?? 0) * CGFloat(self.columns - 1)) / CGFloat(self.columns)
            let expectedHeight = (geometry.size.height - (self.rowSpacing ?? 0) * CGFloat(rows.count - 1)) / CGFloat(rows.count)
            return AnyView(
                VStack(alignment: self.rowAlignment, spacing: self.rowSpacing) {
                    ForEach(0..<rows.count, id: \.self) { row in
                        HStack(alignment: self.columnAlignment, spacing: self.columnSpacing) {
                            ForEach(0..<rows[row].count, id: \.self) { column in
                                rows[row][column].frame(maxWidth: expectedWidth, maxHeight: expectedHeight)
                            }
                        }
                    }
                }.frame(width: geometry.size.width, height: geometry.size.height)
            )
        }
    }
}

// MARK: - Based on ForEach

#if swift(>=5.3)
extension GridView {

    public init<Data : RandomAccessCollection, ID: Hashable, Content: View>(_ data: Data,
                                                                  id: KeyPath<Data.Element, ID>,
                                                                  columns: Int,
                                                                  columnAlignment: VerticalAlignment = .center,
                                                                  columnSpacing: CGFloat? = nil,
                                                                  rowAlignment: HorizontalAlignment = .center,
                                                                  rowSpacing: CGFloat? = nil,
                                                                  @ViewBuilder content: @escaping (Data.Element) -> Content) {

        self.init(columns: columns, columnAlignment: columnAlignment, columnSpacing: columnSpacing, rowAlignment: rowAlignment, rowSpacing: rowSpacing) {
            ForEach(data, id: id, content: content)
        }
    }

    public init<Data : RandomAccessCollection, Content: View>(_ data: Data,
                                                              columns: Int,
                                                              columnAlignment: VerticalAlignment = .center,
                                                              columnSpacing: CGFloat? = nil,
                                                              rowAlignment: HorizontalAlignment = .center,
                                                              rowSpacing: CGFloat? = nil,
                                                              @ViewBuilder content: @escaping (Data.Element) -> Content) where Data.Element: Identifiable {

        self.init(columns: columns, columnAlignment: columnAlignment, columnSpacing: columnSpacing, rowAlignment: rowAlignment, rowSpacing: rowSpacing) {
            ForEach(data, content: content)
        }
    }

    public init<Content: View>(_ range: Range<Int>,
                               columns: Int,
                               columnAlignment: VerticalAlignment = .center,
                               columnSpacing: CGFloat? = nil,
                               rowAlignment: HorizontalAlignment = .center,
                               rowSpacing: CGFloat? = nil,
                               @ViewBuilder content: @escaping (Int) -> Content) {

        self.init(columns: columns, columnAlignment: columnAlignment, columnSpacing: columnSpacing, rowAlignment: rowAlignment, rowSpacing: rowSpacing) {
            ForEach(range, content: content)
        }
    }

}
#endif

// MARK: - Filling Grid Cell by Cell

#if swift(>=5.3)
extension GridView {

    public init<Content: View>(rows: Int,
                               columns: Int,
                               columnAlignment: VerticalAlignment = .center,
                               columnSpacing: CGFloat? = nil,
                               rowAlignment: HorizontalAlignment = .center,
                               rowSpacing: CGFloat? = nil,
                               @ViewBuilder content: @escaping (Int, Int) -> Content) {

        self.init(columns: columns, columnAlignment: columnAlignment, columnSpacing: columnSpacing, rowAlignment: rowAlignment, rowSpacing: rowSpacing) {
            ForEach(0..<rows, id: \.self) { row in
                ForEach(0..<columns, id: \.self) { column in
                    content(row, column)
                }
            }
        }
    }

}
#endif

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#if DEBUG
struct ContentViewPreview: PreviewProvider {
    static var previews: some View {
        GridView(columns: 4) {
            Text("1x1")

            Text("1x2")

            Text("2x1")

            Text("2x2")
        }
    }
}
#endif
