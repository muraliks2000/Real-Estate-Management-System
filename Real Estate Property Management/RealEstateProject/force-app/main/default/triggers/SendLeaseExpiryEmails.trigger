trigger SendLeaseExpiryEmails on Lease_Agreement__c (after insert, after update) {

    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

    for (Lease_Agreement__c lease : Trigger.new) {
    
        if (lease.End_Date__c != null && lease.Property__c != null) {
       
            List<Tenant__c> tenants = [SELECT Email__c, Name, Phone__c 
                                       FROM Tenant__c 
                                       WHERE Property__c = :lease.Property__c];

        
            for (Tenant__c tenant : tenants) {
                if (tenant.Email__c != null) { 

                  
                    Integer daysToExpiry = lease.End_Date__c.daysBetween(Date.today());

                
                    if (daysToExpiry == 30) {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new String[] { tenant.Email__c });
                        email.setSubject('Lease Expiry Notification: 1 Month Remaining');
                        email.setPlainTextBody('Dear ' + tenant.Name + 
                            ',\n\nYour lease agreement for the property will expire on ' + lease.End_Date__c +
                            '. Please contact us for renewal or necessary arrangements.\n\nThank you.');
                        emailsToSend.add(email);
                    }

                 
                    if (daysToExpiry == 1) {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new String[] { tenant.Email__c });
                        email.setSubject('Lease Expiry Reminder: 1 Day Remaining');
                        email.setPlainTextBody('Dear ' + tenant.Name + 
                            ',\n\nThis is a reminder that your lease agreement for the property will expire tomorrow (' + 
                            lease.End_Date__c + '). Please ensure necessary arrangements are made.\n\nThank you.');
                        emailsToSend.add(email);
                    }
                }
            }
        }
    }


    if (!emailsToSend.isEmpty()) {
        Messaging.sendEmail(emailsToSend);
    }
}