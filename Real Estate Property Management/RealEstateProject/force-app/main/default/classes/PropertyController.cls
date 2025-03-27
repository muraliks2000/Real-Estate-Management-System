public with sharing class PropertyController {
    @AuraEnabled(cacheable=true)
    public static PropertyListWrapper getProperties(Integer pageNumber, Integer pageSize, Map<String, Object> filters) {
        String query = 'SELECT Id, Name, Rent__c, Status__c FROM Property__c WHERE Rent__c != NULL';
        
        if (filters != null) {
            if (filters.containsKey('minPrice') && filters.get('minPrice') != null) {
                query += ' AND Rent__c >= ' + filters.get('minPrice');
            }
            if (filters.containsKey('maxPrice') && filters.get('maxPrice') != null) {
                query += ' AND Rent__c <= ' + filters.get('maxPrice');
            }
            if (filters.containsKey('status') && filters.get('status') != '') {
                query += ' AND Status__c = \'' + filters.get('status') + '\'';
            }
            if (filters.containsKey('furnishingStatus') && filters.get('furnishingStatus') != '') {
                query += ' AND FurnishingStatus__c = \'' + filters.get('furnishingStatus') + '\'';
            }
        }

        query += ' LIMIT ' + pageSize + ' OFFSET ' + ((pageNumber - 1) * pageSize);
        
        List<Property__c> properties = Database.query(query);
        Integer totalCount = [SELECT COUNT() FROM Property__c];

        return new PropertyListWrapper(properties, totalCount);
    }

    public class PropertyListWrapper {
        @AuraEnabled public List<Property__c> records;
        @AuraEnabled public Integer totalCount;

        public PropertyListWrapper(List<Property__c> records, Integer totalCount) {
            this.records = records;
            this.totalCount = totalCount;
        }
    }
}