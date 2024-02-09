import ballerinax/mysql;
import ballerinax/mysql.driver as _; 
import ballerina/sql;

public type Book record {|
    int id?;
    string book_title;
    string author;
    string category;
    int published_year;
    decimal price;
    int copies_in_stock;
|};

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database=DATABASE
);

isolated function addBook(Book book) returns int|error {
    
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO books (book_title, author, category, published_year,
                               price, copies_in_stock)
        VALUES (${book.book_title}, ${book.author}, ${book.category},  
                ${book.published_year}, ${book.price}, ${book.copies_in_stock})
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

isolated function getBook(int id) returns Book|error {
    Book book = check dbClient->queryRow(
        `SELECT * FROM books WHERE id = ${id}`
    );
    return book;
}

isolated function getAllBooks() returns Book[]|error {
    Book[] books = [];
    stream<Book, error?> resultStream = dbClient->query(
        `SELECT * FROM books`
    );
    check from Book book in resultStream
        do {
            books.push(book);
        };
    check resultStream.close();
    return books;
}

isolated function updateBook(Book book) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        UPDATE books SET
            book_title = ${book.book_title}, 
            author = ${book.author},
            category = ${book.category},
            published_year = ${book.published_year},
            price = ${book.price}, 
            copies_in_stock = ${book.copies_in_stock}
        WHERE id = ${book.id}  
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

isolated function removeBook(int id) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        DELETE FROM books WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count");
    }
}