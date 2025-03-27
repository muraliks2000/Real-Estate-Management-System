trigger AssignMaintenanceRequestToVendor on Maintenance_Request__c (before insert) {
    // Map to store the workload count for each vendor
    Map<Id, Integer> vendorWorkload = new Map<Id, Integer>();

    // Query all vendors and calculate their current workload
    for (AggregateResult result : [SELECT Vendor__c, COUNT(Id) RequestCount
                                    FROM Maintenance_Request__c
                                    WHERE Status__c != 'Completed'
                                    GROUP BY Vendor__c]) {
        vendorWorkload.put((Id) result.get('Vendor__c'), (Integer) result.get('RequestCount'));
    }

    // Query all active vendors
    List<Vendor__c> vendors = [SELECT Id FROM Vendor__c];

    // Ensure every vendor has an initial workload count
    for (Vendor__c vendor : vendors) {
        if (!vendorWorkload.containsKey(vendor.Id)) {
            vendorWorkload.put(vendor.Id, 0); // Default workload to 0 for vendors without assigned requests
        }
    }

    // Iterate through incoming maintenance requests and assign them
    for (Maintenance_Request__c request : Trigger.new) {
        if (request.Vendor__c == null) { // Only assign if no vendor is pre-selected
            // Initialize variables to find the vendor with the least workload
            Id leastWorkloadVendorId = null;
            Integer leastWorkload = 999999; // Set a large initial value

            // Find the vendor with the least workload
            for (Id vendorId : vendorWorkload.keySet()) {
                Integer workload = vendorWorkload.get(vendorId);
                if (workload < leastWorkload) {
                    leastWorkload = workload;
                    leastWorkloadVendorId = vendorId;
                }
            }

            // Validate if a vendor was found before assigning
            if (leastWorkloadVendorId != null) {
                // Assign the maintenance request to the vendor with the least workload
                request.Vendor__c = leastWorkloadVendorId;

                // Increment the vendor's workload count
                vendorWorkload.put(leastWorkloadVendorId, vendorWorkload.get(leastWorkloadVendorId) + 1);
            } else {
                // Handle the case where no vendors are available
                System.debug('No vendors are available to assign the maintenance request.');
            }
        }
    }
}