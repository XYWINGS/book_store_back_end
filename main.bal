import ballerina/http;
import ballerina/persist;
import book_store.store;


final store:Client sClient = check new();


service /books on new http:Listener(8080) {


   isolated resource function post .(store:BookInsert book) returns int|error? {
       int[] bookIds = check sClient->/books.post([book]);
       return bookIds[0];
   }
  
   isolated resource function get [int id]() returns store:Book|error {
       return check sClient->/books/[id];
   }
  
   resource function get .() returns store:Book[]|error? {
       stream<store:Book, persist:Error?> resultStream = sClient->/books;
       return check from store:Book book in resultStream
           select book;
   }


   isolated resource function put [int id](store:BookUpdate book) returns store:Book|error? {
       return check sClient->/books/[id].put(book);
   }
  
   isolated resource function delete [int id]() returns store:Book|error? {
       return check sClient->/books/[id].delete();      
   }
}