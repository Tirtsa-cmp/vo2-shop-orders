Savepoint sp = Database.setSavepoint();try{
List<Account> accounts = new List<Account>();
accounts.add(new Account(Name = 'ELEVE Maison Elowen', BillingCity = 'Paris'));
accounts.add(new Account(Name = 'ELEVE Comptoir Lémieux', BillingCity = 'Lyon'));
accounts.add(new Account(Name = 'ELEVE Galerie Serein', BillingCity = 'Paris'));
accounts.add(new Account(Name = 'ELEVE Atelier Nova', BillingCity = 'Lille'));
insert accounts;

Map<String, Id> accountIdByName = new Map<String, Id>();
for (Account a : accounts) {
    accountIdByName.put(a.Name, a.Id);
}

List<Contact> contacts = new List<Contact>();
contacts.add(new Contact(FirstName = 'Inès', LastName = 'Marchal', AccountId = accountIdByName.get('ELEVE Maison Elowen'), Email = 'ines.marchal@eleve.test', Title = 'Head of Programmes'));
contacts.add(new Contact(FirstName = 'Paul', LastName = 'Sernin', AccountId = accountIdByName.get('ELEVE Comptoir Lémieux'), Email = 'paul.sernin@eleve.test', Title = 'Operartions'));
contacts.add(new Contact(FirstName = 'Chloé', LastName = 'Adler', AccountId = accountIdByName.get('ELEVE Galerie Serein'), Email = 'chloe.adler@eleve.test', Title = 'Director'));
contacts.add(new Contact(FirstName = 'Marc', LastName = 'Duhamel', AccountId = accountIdByName.get('ELEVE Atelier Nova'), Email = 'marc.duhamel@eleve.test', Title = 'Facilitator'));
contacts.add(new Contact(FirstName = 'Léa', LastName = 'Benamou', AccountId = accountIdByName.get('ELEVE Atelier Nova'), Email = 'lea.benamou@eleve.test', Title = 'Facilitator'));
contacts.add(new Contact(FirstName = 'Yael', LastName = 'Costa', AccountId = accountIdByName.get('ELEVE Atelier Nova'), Email = 'yael.costa@eleve.test', Title = 'Facilitator'));
insert contacts;

Map<String, Id> contactIdByName = new Map<String, Id>();
for (Contact c : contacts) {
    contactIdByName.put(c.FirstName + ' ' + c.LastName, c.Id);
}

List<Skill__c> skills = new List<Skill__c>();
skills.add(new Skill__c(Name = 'Facilitation', Description__c = 'Facilitation skills for group sessions'));
skills.add(new Skill__c(Name = 'Workshop Design', Description__c = 'Managing projects and timelines'));
skills.add(new Skill__c(Name = 'Client Brief', Description__c = 'Effective communication strategies'));
insert skills;

Map<String, Id> skillIdByName = new Map<String, Id>();
for (Skill__c s : skills) {
    skillIdByName.put(s.Name, s.Id);
}

List<ContactSkills__c> contactSkills = new List<ContactSkills__c>();
contactSkills.add(new ContactSkills__c(ContactSkillsToContact__c = contactIdByName.get('Marc Duhamel'), ContactSkillsToSkill__c = skillIdByName.get('Facilitation'), Level__c = 'Expert'));
contactSkills.add(new ContactSkills__c(ContactSkillsToContact__c = contactIdByName.get('Marc Duhamel'), ContactSkillsToSkill__c = skillIdByName.get('Workshop Design'), Level__c = 'Confirmed'));
contactSkills.add(new ContactSkills__c(ContactSkillsToContact__c = contactIdByName.get('Léa Benamou'), ContactSkillsToSkill__c = skillIdByName.get('Workshop Design'), Level__c = 'Expert'));
contactSkills.add(new ContactSkills__c(ContactSkillsToContact__c = contactIdByName.get('Léa Benamou'), ContactSkillsToSkill__c = skillIdByName.get('Facilitation'), Level__c = 'Confirmed'));
contactSkills.add(new ContactSkills__c(ContactSkillsToContact__c = contactIdByName.get('Yael Costa'), ContactSkillsToSkill__c = skillIdByName.get('Client Brief'), Level__c = 'Beginner'));
contactSkills.add(new ContactSkills__c(ContactSkillsToContact__c = contactIdByName.get('Yael Costa'), ContactSkillsToSkill__c = skillIdByName.get('Facilitation'), Level__c = 'Confirmed'));
insert contactSkills;

List<Workshop__c> workshops = new List<Workshop__c>();
workshops.add(new Workshop__c(Name = 'ELEVE-ELW-1020', client__c = accountIdByName.get('ELEVE Maison Elowen'), Status__c = 'Confirmed', StartingDay__c = Date.today() + 10, EndingDate__c = Date.today() + 11,Place__c= 'on-Site', Room__c = 'Salle Lumière', Requister__c = contactIdByName.get('Inès Marchal')));
workshops.add(new Workshop__c(Name = 'ELEVE-LMX-1103', client__c = accountIdByName.get('ELEVE Comptoir Lémieux'), Status__c = 'Planned', StartingDay__c = Date.today() + 20, EndingDate__c = Date.today() + 20,Place__c='Remote', Requister__c = contactIdByName.get('Paul Sernin')));
workshops.add(new Workshop__c(Name = 'ELEVE-SRN-0908', client__c = accountIdByName.get('ELEVE Galerie Serein'), Status__c = 'Done', StartingDay__c = Date.today() - 30, EndingDate__c = Date.today() - 29, Place__c = 'on-Site', Room__c = 'Atelier 1', Requister__c = contactIdByName.get('Chloé Adler')));
workshops.add(new Workshop__c(Name = 'ELEVE-W-REM', client__c = accountIdByName.get('ELEVE Maison Elowen'), Status__c = 'Planned', StartingDay__c = Date.today() + 5, EndingDate__c = Date.today() + 6,Place__c='Remote', Requister__c = contactIdByName.get('Inès Marchal')));
workshops.add(new Workshop__c(Name = 'ELEVE-VIDE', client__c = accountIdByName.get('ELEVE Galerie Serein'), Status__c = 'Planned', StartingDay__c = Date.today() + 40, EndingDate__c = Date.today() + 41,Place__c='On-Site', Room__c='Salle 2'));
insert workshops;

Map<String, Id> workshopIdByName = new Map<String, Id>();
for (Workshop__c w : workshops) {
    workshopIdByName.put(w.Name, w.Id);
}

List<WorkshopLine__c> workshopLines = new List<WorkshopLine__c>();
workshopLines.add(new WorkshopLine__c(Workshop__c = workshopIdByName.get('ELEVE-ELW-1020'), Cost__c = 1800, Lecturer__c = contactIdByName.get('Marc Duhamel')));
workshopLines.add(new WorkshopLine__c(Workshop__c = workshopIdByName.get('ELEVE-ELW-1020'), Cost__c = 950, Lecturer__c = contactIdByName.get('Léa Benamou')));
workshopLines.add(new WorkshopLine__c(Workshop__c = workshopIdByName.get('ELEVE-LMX-1103'), Cost__c = 600, Lecturer__c = contactIdByName.get('Yael Costa')));
workshopLines.add(new WorkshopLine__c(Workshop__c = workshopIdByName.get('ELEVE-SRN-0908'), Cost__c = 1600, Lecturer__c = contactIdByName.get('Marc Duhamel')));
workshopLines.add(new WorkshopLine__c(Workshop__c = workshopIdByName.get('ELEVE-SRN-0908'), Cost__c = 900, Lecturer__c = contactIdByName.get('Léa Benamou')));
workshopLines.add(new WorkshopLine__c(Workshop__c = workshopIdByName.get('ELEVE-W-REM'), Cost__c = 450));
workshopLines.add(new WorkshopLine__c(Workshop__c = workshopIdByName.get('ELEVE-W-REM'), Cost__c = 215, Lecturer__c = contactIdByName.get('Yael Costa')));
workshopLines.add(new WorkshopLine__c(Workshop__c = workshopIdByName.get('ELEVE-W-REM'), Cost__c = 345, Lecturer__c = contactIdByName.get('Marc Duhamel')));
insert workshopLines;

System.debug('Tout a été inséré avec succès !');
} catch (Exception e) {
    Database.rollback(sp);
    System.debug('Erreur détectée, toute la transaction a été annulée : ' + e.getMessage());
}