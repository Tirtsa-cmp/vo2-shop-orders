delete [SELECT Id FROM WorkshopLine__c WHERE Workshop__r.Name LIKE 'ELEVE%'];
delete [SELECT Id FROM ContactSkills__c WHERE ContactSkillsToContact__r.Account.Name LIKE 'ELEVE%'];
delete [SELECT Id FROM Workshop__c WHERE Name LIKE 'ELEVE%'];
delete [SELECT Id FROM Contact WHERE Account.Name LIKE 'ELEVE%'];
delete [SELECT Id FROM Account WHERE Name LIKE 'ELEVE%'];
delete [SELECT Id FROM Skill__c WHERE Name IN ('Facilitation', 'Workshop Design', 'Client Brief')];

System.debug('Nettoyage terminé !');