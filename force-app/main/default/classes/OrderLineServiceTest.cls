/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class OrderLineServiceTest {

    @isTest
    static void myUnitTest1() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Product__c product1 = new Product__c(Name = 'Product 1', Unit_Price__c = 10,SKU__c='P1');
        Product__c product2 = new Product__c(Name = 'Product 2', Unit_Price__c = 20,SKU__c='P2');
        insert new List<Product__c>{product1, product2};    
        
        Order__c order1 = new Order__c(Name = 'Test Order', Account__c = account.Id, Status__c = 'Confirmed');
        Order__c order2 = new Order__c(Name = 'Test Order', Account__c = account.Id, Status__c = 'Confirmed');
        insert new List<Order__c>{order1, order2};
        Test.startTest();
       
        Order_Line__c line1 = new Order_Line__c(Product__c = product1.Id, Quantity__c = 4, Order__c = order1.Id );
        Order_Line__c line2 = new Order_Line__c(Product__c = product2.Id, Quantity__c = 3, Order__c = order2.Id); 
        insert new List<Order_Line__c>{line1, line2};
        Test.stopTest();
        // Verify that the Unit_Price and Line_Total fields are set correctly
        line1 = [SELECT Unit_Price__c, Line_Total__c FROM Order_Line__c WHERE Id = :line1.Id];
        line2 = [SELECT Unit_Price__c, Line_Total__c FROM Order_Line__c WHERE Id = :line2.Id];

        System.assertEquals(10, line1.Unit_Price__c);
        System.assertEquals(20, line2.Unit_Price__c);
        System.assertEquals(40, line1.Line_Total__c); // 10 * 2
        System.assertEquals(60, line2.Line_Total__c); // 20 * 3

        // Update the product price and verify that the order lines are updated accordingly
        line1.Quantity__c = 2;
        update line1;

        // Trigger should have updated the order lines
        line1 = [SELECT Unit_Price__c, Line_Total__c FROM Order_Line__c WHERE Id = :line1.Id];
        System.assertEquals(10, line1.Unit_Price__c);
        System.assertEquals(20, line1.Line_Total__c); // 15 * 2
    }
    @isTest
    static void myUnitTest2() {
    
    }
}