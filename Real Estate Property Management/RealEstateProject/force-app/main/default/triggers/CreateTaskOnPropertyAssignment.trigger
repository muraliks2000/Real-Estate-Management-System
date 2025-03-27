trigger CreateTaskOnPropertyAssignment on Tenant__c (after insert, after update) {
    List<Task> tasksToInsert = new List<Task>();

    for (Tenant__c tenantRecord : Trigger.new) {
        if ((Trigger.isInsert && tenantRecord.Property__c != null) || 
            (Trigger.isUpdate && tenantRecord.Property__c != Trigger.oldMap.get(tenantRecord.Id).Property__c && 
             tenantRecord.Property__c != null)) {

            Task newTask = new Task();
            newTask.Subject = 'Generate Lease Agreement';
            newTask.ActivityDate = Date.today(); // Task due date
            newTask.OwnerId = tenantRecord.CreatedById; // Assign task to creator

            // Store property information in the description
            newTask.Description = 'Please generate a lease agreement for the assigned property: ' + tenantRecord.Property__c;

            tasksToInsert.add(newTask);
        }
    }

    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;
    }
}