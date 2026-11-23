public with sharing class ContactSearch {
    public static List<Contact>searchForContacts(String lastName, String email) {
return[select Id,Name FROM Contact WHERE lastName = :lastName and MailingPostalCode = :email];

    }
}