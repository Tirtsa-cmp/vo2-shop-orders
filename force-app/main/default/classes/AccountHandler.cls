public with sharing class AccountHandler {
   
    public static Account insertNewAccount(String acc_name) 
    {
         try {// Insert new Account record with the provided name
        Account acc = new Account(Name=acc_name);
        insert acc;
        return acc;
    }

    catch (DmlException e)
    {system.debug('An error occurred while inserting the account: ' + e.getMessage());
return null;}
    }
}