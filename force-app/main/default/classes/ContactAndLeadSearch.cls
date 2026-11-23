public with sharing class ContactAndLeadSearch {
    
    public static List<List< sObject>> searchContactsAndLeads(String match_string) {
  
return [FIND :match_string IN NAME FIELDS RETURNING Contact(Id, FirstName, LastName, Email), Lead(Id, FirstName, LastName, Email)];
    }
}