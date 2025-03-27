public class dummyInsert {

    public static void insertDummyData() {
        // Insert Properties
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 1; i <= 5; i++) {
            properties.add(new Property__c(
                Name = 'Property ' + i,
                Address__c = 'Address ' + i,
                City__c = 'City ' + i,
                State__c = 'State ' + i,
                Postal_Code__c = 500000 + i,
                Country__c = 'India',
                Type__c = 'Residential',
                Furnishing_Status__c = 'Furnished',
                Status__c = (Math.mod(i, 2) == 0 ? 'Occupied' : 'Available'),
                Rent__c = 10000 + (i * 500),
                Description__c = 'Description for Property ' + i
            ));
        }
        insert properties;

        // Insert Tenants
        List<Tenant__c> tenants = new List<Tenant__c>();
        for (Integer i = 1; i <= 5; i++) {
            tenants.add(new Tenant__c(
                Name = 'Tenant ' + i,
                Phone__c = '123456789' + i,
                Email__c = 'tenant' + i + '@example.com',
                Property__c = properties[i - 1].Id
            ));
        }
        insert tenants;

        // Insert Lease Agreements
 
    }
}