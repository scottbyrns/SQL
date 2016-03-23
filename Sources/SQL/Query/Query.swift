// Query.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Formbound
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


public protocol Query: QueryComponentRepresentable {}

public extension Query {
//    public func execute<T: Connection>(connection: T) throws -> T.ResultType {
//        return try connection.execute(self)
//    }
}

public protocol TableQuery: Query {
    var tableName: String { get }
}

//public protocol ModelQuery: TableQuery {
//    associatedtype ModelType: Model
//}

//public extension ModelQuery where Self: FetchQuery {
//    public func fetch<T: Connection where T.ResultType.Iterator.Element == Row>(connection: T) throws -> [ModelType] {
//        return try connection.execute(self).map { try ModelType(row: $0) }
//    }
//
//    public func first<T: Connection where T.ResultType.Iterator.Element == Row>(connection: T) throws -> ModelType? {
//        var new = self
//        new.offset = 0
//        new.limit = 1
//        return try connection.execute(new).map { try ModelType(row: $0) }.first
//    }
//
//    public func orderBy(values: [ModelOrderBy<ModelType>]) -> Self {
//        return orderBy(values.map { $0.normalize })
//    }
//
//    public func orderBy(values: ModelOrderBy<ModelType>...) -> Self {
//        return orderBy(values)
//    }
//}

public struct Limit: QueryComponentRepresentable {
    public let value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
    
    public var queryComponent: QueryComponent {
        return .limit(value)
    }
}

extension Limit: IntegerLiteralConvertible {
    public init(integerLiteral value: Int) {
        self.value = value
    }
}

public struct Offset: QueryComponentRepresentable {
    public let value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
    
    public var queryComponent: QueryComponent {
        return .offset(value)
    }
}

extension Offset: IntegerLiteralConvertible {
    public init(integerLiteral value: Int) {
        self.value = value
    }
}

//public enum OrderBy: QueryComponentRepresentable {
//    case Ascending(String)
//    case Descending(String)
//
//    public var queryComponent: QueryComponent {
//        switch self {
//        case .Ascending(let field):
//            return queryComponent(strings: [field, "ASC"])
//        case .Descending(let field):
//            return queryComponent(strings: [field, "DESC"])
//        }
//    }
//}

public struct GroupBy: QueryComponentRepresentable {
    private var field: DeclaredField
    public init(_ field: DeclaredField) {
        self.field = field
    }
    public var queryComponent: QueryComponent {
        return .groupBy(parts: .parts([field.queryComponent]))
    }
}

//public struct Having: QueryComponentRepresentable {
//    public var queryComponent: queryComponent {
//        return queryComponent(strings: ["HAVING", String(value)])
//    }
//}

//public enum DeclaredFieldOrderBy {
//    case Ascending(DeclaredField)
//    case Descending(DeclaredField)
//
//    public var normalize: OrderBy {
//        switch self {
//        case .Ascending(let field):
//            return .Ascending(field.qualifiedName)
//        case .Descending(let field):
//            return .Descending(field.qualifiedName)
//        }
//    }
//}

//public enum ModelOrderBy<T: Model> {
//    case Ascending(T.Field)
//    case Descending(T.Field)
//
//    public var normalize: DeclaredFieldOrderBy {
//        switch self {
//        case .Ascending(let field):
//            return .Ascending(T.field(field))
//        case .Descending(let field):
//            return .Descending(T.field(field))
//        }
//    }
//}
//
//public extension Sequence where Self.Iterator.Element == OrderBy {
//    public var queryComponent: queryComponent {
//        return queryComponent(components: map { $0.queryComponent })
//    }
//}
//
public protocol FetchQuery: TableQuery {
    var offset: Offset? { get set }
    var limit: Limit? { get set }
//    var orderBy: [OrderBy] { get set }
    var groupBy: [GroupBy] { get set }
}

//
//public extension FetchQuery {
//    public var pageSize: Int? {
//        get {
//            return limit?.value
//        }
//        set {
//            guard let value = newValue else {
//                limit = nil
//                return
//            }
//            limit = Limit(value)
//        }
//    }
//
//    public func page(value: Int?) -> Self {
//        var new = self
//        new.page = value
//        return new
//    }
//
//    public func pageSize(value: Int?) -> Self {
//        var new = self
//        new.pageSize = value
//        return new
//    }
//
//    public var page: Int? {
//        set {
//            guard let value = newValue, limit = limit else {
//                offset = nil
//                return
//            }
//            offset = Offset(value * limit.value)
//        }
//
//        get {
//            guard let offset = offset, limit = limit else {
//                return nil
//            }
//
//            return offset.value / limit.value
//        }
//    }
//
//    public func orderBy(values: [OrderBy]) -> Self {
//        var new = self
//        new.orderBy.append(contentsOf: values)
//        return new
//    }
//
//    public func orderBy(values: OrderBy...) -> Self {
//        return orderBy(values)
//    }
//
//    public func orderBy(values: [DeclaredFieldOrderBy]) -> Self {
//        return orderBy(values.map { $0.normalize })
//    }
//
//    public func orderBy(values: DeclaredFieldOrderBy...) -> Self {
//        return orderBy(values)
//    }
//
//    public func groupBy(fields: DeclaredField...) -> Self {
//        var new = self
//        new.groupBy.append(contentsOf: fields.map { GroupBy($0) } )
//        return new
//    }
//
//    public func limit(value: Int?) -> Self {
//        var new = self
//        if let value = value {
//            new.limit = Limit(value)
//        }
//        else {
//            new.limit = nil
//        }
//        return new
//    }
//
//    public func offset(value: Int?) -> Self {
//        var new = self
//        if let value = value {
//            new.offset = Offset(value)
//        }
//        else {
//            new.offset = nil
//        }
//        return new
//    }
//}
//
public protocol FilteredQuery: Query {
//    var condition: Condition? { get set }
}
//
extension FilteredQuery {
//    public func filter(condition: Condition) -> Self {
//        let newCondition: Condition
//        if let existing = self.condition {
//            newCondition = .And([existing, condition])
//        }
//        else {
//            newCondition = condition
//        }
//
//        var new = self
//        new.condition = newCondition
//
//        return new
//    }
}
//
//
//public struct Join: QueryComponentRepresentable {
//    public enum JoinType: QueryComponentRepresentable {
//        case Inner
//        case Outer
//        case Left
//        case Right
//
//        public var queryComponent: queryComponent {
//            switch self {
//            case .Inner:
//                return "INNER"
//            case .Outer:
//                return "OUTER"
//            case .Left:
//                return "LEFT"
//            case .Right:
//                return "RIGHT"
//            }
//        }
//    }
//
//    public let tableClause: queryComponent
//    public let types: [JoinType]
//    public let leftKey: queryComponent
//    public let rightKey: queryComponent
//
//    public init(_ tableClause: queryComponent, type: [JoinType], leftKey: QueryComponentRepresentable, rightKey: QueryComponentRepresentable) {
//        self.tableClause = tableClause
//        self.types = type
//        self.leftKey = leftKey.queryComponent
//        self.rightKey = rightKey.queryComponent
//    }
//
//    public var queryComponent: queryComponent {
//        return "\(types) JOIN \(tableClause) on \(leftKey) = \(rightKey)"
////        return queryComponent(components: [
////            types.queryComponent,
////            "JOIN",
////            tableClause,
////            "ON",
////            leftKey,
////            "=",
////            rightKey
////            ]
////        )
//    }
//}
//
//
public struct Subquery: QueryComponentRepresentable {
    private let query: QueryComponent
    let alias: String
    public init(query: QueryComponent, alias: String) {
        self.query = query
        self.alias = alias
    }
//    public func field(name: String) -> String {
//        return "\(self.alias).\(name)"
//    }
    public var queryComponent: QueryComponent {
        return .subquery(query: query, alias: alias)
    }
}

//
//extension Subquery: SQLDataRepresentable {
//    public var sqlData: SQLData {
//        return .RawSQL(self.queryComponent.string)
//    }
//}