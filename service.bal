import ballerina/http;

service /books on new http:Listener(8080) {

    isolated resource function post .(@http:Payload Book book) returns int|error? {
        return addBook(book);
    }
    
    isolated resource function get [int id]() returns Book|error? {
        return getBook(id);
    }
    
    isolated resource function get .() returns Book[]|error? {
        return getAllBooks();
    }
    
    isolated resource function put .(@http:Payload Book book) returns int|error? {
        return updateBook(book);
    }
    
    isolated resource function delete [int id]() returns int|error? {
        return removeBook(id);       
    }

}